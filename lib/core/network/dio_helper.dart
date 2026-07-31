import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services/auth_interceptor.dart';
import '../services/service_locator.dart';
import '../services/token_service/token_storage.dart';
import 'api_constant.dart';
import 'authorization_header.dart';
import '../services/app_locle.dart';

class DioHelper {
  static Dio? dio;

  static TokenStorage get _tokenStorage => sl<TokenStorage>();

  static Future<void> init() async {
    final client = Dio(
      BaseOptions(
        baseUrl: ApiConstants.reefBaseUrl,
        receiveDataWhenStatusError: true,
        headers: AuthorizationHeader.defaultBaseHeaders(),
      ),
    );
    dio = client;

    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await AuthorizationHeader.applyStandard(options, _tokenStorage);
          if (options.data is FormData) {
            options.headers.remove('Content-Type');
          }
          final auth = options.headers[AuthorizationHeader.headerKey];
          log(
            'DioHelper - ${options.method} ${options.path} | '
            '${AuthorizationHeader.headerKey}: ${auth ?? '(none)'}',
          );
          return handler.next(options);
        },
      ),
    );

    client.interceptors.add(AuthInterceptor(client));

    if (!kReleaseMode) {
      client.interceptors.add(
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
    final lang = await AppLocale.getSavedLanguage();
    if (dio != null) {
      dio!.options.headers = {
        'Accept-Language': lang,
      };
    }
  }

  static Future<String?> getAccessToken() => _tokenStorage.getToken();

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    ResponseType? responseType,
  }) async {
    await syncHeaders(path: url);
    return dio!.get(
      url,
      queryParameters: query,
      options: responseType == null
          ? null
          : Options(responseType: responseType),
    );
  }

  static Future<Response> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    await syncHeaders(path: url);
    return dio!.post(url, data: data, queryParameters: query, options: options);
  }

  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    bool legacyAuthQuery = true,
  }) async {
    await syncHeaders(path: url);
    if (!legacyAuthQuery) {
      return dio!.put(
        url,
        data: data,
        queryParameters: query,
        options: options,
      );
    }

    final token = await _tokenStorage.getToken();
    final userId = await _tokenStorage.getLegacyUserId();

    return dio!.put(
      '$url?access-token=$token&id=$userId',
      data: data,
      queryParameters: query,
      options: options,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
  }) async {
    await syncHeaders(path: url);
    final token = await _tokenStorage.getToken();
    final userId = await _tokenStorage.getLegacyUserId();

    return dio!.delete(
      '$url?access-token=$token&id=$userId',
      queryParameters: query,
      data: data,
    );
  }
}
