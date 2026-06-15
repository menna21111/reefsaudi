import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../funcation.dart';
import '../network/pmo_endpoints.dart';
import '../utils/app_color.dart';
import '../../features/auth/presination/screans/login_screan.dart';
import 'service_locator.dart';
import 'token_service/token_storage.dart';

class AuthInterceptor extends Interceptor {
  static bool _isHandlingAuthError = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('AuthInterceptor - Request sending: ${options.method} ${options.uri}');
    log(
      'AuthInterceptor - Authorization: ${options.headers['Authorization'] ?? '(none)'}',
    );
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final path = err.requestOptions.path;
    final isLoginRequest = PmoEndpoints.isLoginPath(path);

    if (err.response?.statusCode == 401 && !isLoginRequest) {
      log('401 Unauthorized detected on non-login request, redirecting to login');
      _handleInvalidToken(err.requestOptions);
    } else if (err.response?.data != null &&
        _isInvalidTokenResponse(err.response!.data)) {
      log('Invalid token detected in error body, redirecting to login');
      if (!isLoginRequest) {
        _handleInvalidToken(err.requestOptions);
      }
    }
    super.onError(err, handler);
  }

  bool _isInvalidTokenResponse(dynamic responseData) {
    log('AuthInterceptor - Checking response data: $responseData');

    if (responseData is String) {
      try {
        // Try to parse JSON string
        final Map<String, dynamic> jsonData = const JsonDecoder().convert(
          responseData,
        );
        return _checkInvalidTokenInMap(jsonData);
      } catch (e) {
        log('AuthInterceptor - Failed to parse JSON string: $e');
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

    log('AuthInterceptor - Checking: status=$status, message=$message');

    // Check for exact match with the message you provided
    if (message == 'Invalid token.' && status == 'fail') {
      log('AuthInterceptor - Exact match found!');
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
      if (context != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScrean()),
          (route) => false,
        );

        AppFunctions.showsToast(
          'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
          AppColor.kRedColor,
          context,
        );
      }
    } catch (e) {
      log('Error handling invalid token: $e');
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        _isHandlingAuthError = false;
      });
    }
  }
}
