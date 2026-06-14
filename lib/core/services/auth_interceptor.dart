import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../funcation.dart';
import '../network/authorization_header.dart';
import '../network/pmo_endpoints.dart';
import '../utils/app_color.dart';
import 'service_locator.dart';
import 'token_service/token_refresh_service.dart';
import 'token_service/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;
  bool _isLoggingOut = false;

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
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (!_isInvalidTokenResponse(response.data)) {
      super.onResponse(response, handler);
      return;
    }

    final retried = await _retryAfterRefresh(response.requestOptions);
    if (retried != null) {
      handler.resolve(retried);
      return;
    }

    await _handleInvalidToken();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldAttemptRefresh(err)) {
      super.onError(err, handler);
      return;
    }

    final retried = await _retryAfterRefresh(err.requestOptions);
    if (retried != null) {
      handler.resolve(retried);
      return;
    }

    await _handleInvalidToken();
    super.onError(err, handler);
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

    final normalizedMessage = message?.toString().toLowerCase() ?? '';
    return normalizedMessage.contains('invalid token') ||
        normalizedMessage.contains('unauthorized') ||
        normalizedMessage.contains('token expired');
  }

  Future<void> _handleInvalidToken() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await sl<TokenStorage>().clearToken();

      final context = navigatorKey.currentContext;
      if (context == null || !context.mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );

      AppFunctions.showsToast(
        'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
        AppColor.kRedColor,
        context,
      );
    } catch (e) {
      log('Error handling invalid token: $e');
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        _isLoggingOut = false;
      });
    }
  }
}
