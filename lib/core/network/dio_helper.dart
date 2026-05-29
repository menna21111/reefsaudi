import 'dart:developer';
import 'package:intl/intl.dart';


import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services/app_locle.dart';
import '../services/auth_interceptor.dart';
import '../services/service_locator.dart';
import '../services/token_service/token_storage.dart';
import 'api_constant.dart';



class DioHelper {
  // static final AppPreferences _appPreferences = instance<AppPreferences>();
  static Dio? dio;

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );

    dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accestoken = await sl<TokenStorage>().getToken();
        String lang = await AppLocale.getSavedLanguage();

        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept-Language'] = lang;
        if (accestoken != null) {
          options.headers['Authorization'] = 'Bearer $accestoken';
        }
        return handler.next(options);
      },
    ));

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

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    return dio!.post(url, data: data, queryParameters: query);
  }

  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    final token = await sl<TokenStorage>().getToken();
    final userId = await sl<TokenStorage>().getUserId();

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
    final token = await sl<TokenStorage>().getToken();
    final userId = await sl<TokenStorage>().getUserId();

    return dio!.delete(
      '$url?access-token=$token&id=$userId',
      queryParameters: query,
    );
  }
}
