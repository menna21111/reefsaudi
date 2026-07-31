import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../navigation/app_navigator.dart';
import '../funcation.dart';
import '../network/authorization_header.dart';
import '../network/pmo_endpoints.dart';
import '../utils/app_color.dart';
import '../utils/app_string.dart';
import '../../features/auth/presination/screans/login_screan.dart';
import 'service_locator.dart';
import 'token_service/token_refresh_service.dart';
import 'token_service/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;
  static bool _isHandlingAuthError = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!PmoEndpoints.isPublicAuthPath(AuthorizationHeader.requestPath(options))) {
      final refreshService = sl<TokenRefreshService>();
      if (await refreshService.shouldRefreshProactively()) {
        await refreshService.refreshAccessToken();
        final auth = AuthorizationHeader.bearerValue(
          await sl<TokenStorage>().getToken(),
        );
        if (auth != null) {
          options.headers[AuthorizationHeader.headerKey] = auth;
        }
      }
    }

    log('AuthInterceptor - Request sending: ${options.method} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // log('AuthInterceptor - Response received: ${response.data}');
    if (_isInvalidTokenResponse(response.data)) {
      log('Invalid token detected, redirecting to login');
      _handleInvalidToken(response.requestOptions);
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Invalid token detected',
        ),
      );
    }
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final path = err.requestOptions.path;
    final isLoginRequest = PmoEndpoints.isLoginPath(path);

    if (_shouldAttemptRefresh(err)) {
      final response = await _retryAfterRefresh(err.requestOptions);
      if (response != null) {
        return handler.resolve(response);
      }
      if (!isLoginRequest) {
        log('401 Unauthorized after refresh failed, redirecting to login');
        _handleInvalidToken(err.requestOptions);
      }
      return handler.reject(err);
    }

    if (err.response?.data != null &&
        _isInvalidTokenResponse(err.response!.data) &&
        !isLoginRequest) {
      log('Invalid token detected in error body, redirecting to login');
      _handleInvalidToken(err.requestOptions);
    }

    return handler.next(err);
  }

  bool _shouldAttemptRefresh(DioException err) {
    final path = AuthorizationHeader.requestPath(err.requestOptions);
    if (PmoEndpoints.isPublicAuthPath(path)) {
      return false;
    }
    if (err.requestOptions.extra['authRetried'] == true) {
      return false;
    }

    if (err.response?.statusCode == 401) {
      return true;
    }

    return err.response?.data != null &&
        _isInvalidTokenResponse(err.response!.data);
  }

  Future<Response<dynamic>?> _retryAfterRefresh(
    RequestOptions requestOptions,
  ) async {
    if (PmoEndpoints.isPublicAuthPath(
      AuthorizationHeader.requestPath(requestOptions),
    )) {
      return null;
    }
    if (requestOptions.extra['authRetried'] == true) {
      return null;
    }

    log('AuthInterceptor - Attempting token refresh');
    final refreshed = await sl<TokenRefreshService>().refreshAccessToken();
    if (!refreshed) {
      return null;
    }

    try {
      final updatedOptions = requestOptions.copyWith(
        extra: Map<String, dynamic>.from(requestOptions.extra)
          ..['authRetried'] = true,
      );
      final auth = AuthorizationHeader.bearerValue(
        await sl<TokenStorage>().getToken(),
      );
      if (auth != null) {
        updatedOptions.headers[AuthorizationHeader.headerKey] = auth;
      } else {
        updatedOptions.headers.remove(AuthorizationHeader.headerKey);
      }

      return await _dio.fetch<dynamic>(updatedOptions);
    } catch (e, stackTrace) {
      log('AuthInterceptor - Retry failed: $e', stackTrace: stackTrace);
      return null;
    }
  }

  bool _isInvalidTokenResponse(dynamic responseData) {
    if (responseData is String) {
      try {
        final Map<String, dynamic> jsonData = const JsonDecoder().convert(
          responseData,
        );
        return _checkInvalidTokenInMap(jsonData);
      } catch (_) {
        return false;
      }
    } else if (responseData is Map<String, dynamic>) {
      return _checkInvalidTokenInMap(responseData);
    }
    return false;
  }

  bool _checkInvalidTokenInMap(Map<String, dynamic> data) {
    final message = data['message'];
    final status = data['status'];

    if (message == 'Invalid token.' && status == 'fail') {
      return true;
    }

    // Also check for other variations of invalid token messages
    if (message?.toString().toLowerCase().contains('invalid token') == true ||
        message?.toString().toLowerCase().contains('unauthorized') == true ||
        message?.toString().toLowerCase().contains('token expired') == true) {
      log('AuthInterceptor - Pattern match found!');
      return true;
    }

    return false;
  }

  void _handleInvalidToken(RequestOptions options) async {
    if (_isHandlingAuthError) return;
    _isHandlingAuthError = true;

    log('AuthInterceptor - handling invalid token from path: ${options.path}');

    try {
      await sl<TokenStorage>().clearToken();

      final context = navigatorKey.currentContext;
      if (context == null || !context.mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScrean()),
        (route) => false,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppFunctions.showsToast(
          AppString.sessionExpired.tr(),
          AppColor.kRedColor,
          null,
          seconds: 4,
        );
      });
    } catch (e) {
      log('Error handling invalid token: $e');
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        _isHandlingAuthError = false;
      });
    }
  }
}
