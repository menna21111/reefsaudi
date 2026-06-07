import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services/auth_interceptor.dart';
import '../services/service_locator.dart';
import '../services/token_service/token_storage.dart';
import 'api_constant.dart';
import 'authorization_header.dart';

class DioHelper {
  static Dio? dio;

  static TokenStorage get _tokenStorage => sl<TokenStorage>();

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        receiveDataWhenStatusError: true,
        headers: AuthorizationHeader.defaultBaseHeaders(),
      ),
    );

    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await AuthorizationHeader.applyStandard(options, _tokenStorage);
          final auth = options.headers[AuthorizationHeader.headerKey];
          log(
            'DioHelper - ${options.method} ${options.path} | '
            '${AuthorizationHeader.headerKey}: ${auth ?? '(none)'}',
          );
          return handler.next(options);
        },
      ),
    );

    dio?.interceptors.add(AuthInterceptor());

    if (!kReleaseMode) {
      dio?.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }
  }

  static Future<Map<String, dynamic>> headers({
    String path = '',
    bool includeAuth = true,
  }) async {
    return AuthorizationHeader.build(
      storage: _tokenStorage,
      path: path,
      includeAuth: includeAuth,
    );
  }

  static Future<void> syncHeaders({required String path}) async {
    final built = await headers(
      path: path,
      // Keep Authorization per-request only (interceptor), not on shared Dio options.
      includeAuth: false,
    );
    if (dio != null) {
      dio!.options.headers = Map<String, dynamic>.from(built);
      dio!.options.headers.remove(AuthorizationHeader.headerKey);
    }
  }

  static Future<String?> getAccessToken() => _tokenStorage.getToken();

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    await syncHeaders(path: url);
    return dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    await syncHeaders(path: url);
    return dio!.post(url, data: data, queryParameters: query);
  }

  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    await syncHeaders(path: url);
    final token = await _tokenStorage.getToken();
    final userId = await _tokenStorage.getLegacyUserId();

    return dio!.put(
      '$url?access-token=$token&id=$userId',
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    await syncHeaders(path: url);
    final token = await _tokenStorage.getToken();
    final userId = await _tokenStorage.getLegacyUserId();

    return dio!.delete(
      '$url?access-token=$token&id=$userId',
      queryParameters: query,
    );
  }
}
