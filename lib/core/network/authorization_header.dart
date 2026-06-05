import 'package:dio/dio.dart';

import '../services/app_locle.dart';
import '../services/token_service/token_storage.dart';
import 'pmo_endpoints.dart';

class AuthorizationHeader {
  static const String headerKey = 'Authorization';

  static String? bearerValue(String? accessToken) {
    final trimmed = accessToken?.trim();
    if (trimmed == null ||
        trimmed.isEmpty ||
        trimmed.toLowerCase() == 'null') {
      return null;
    }
    return 'Bearer $trimmed';
  }

  static Map<String, dynamic> defaultBaseHeaders() => {
        'Content-Type': 'application/json',
      };

  static Future<Map<String, dynamic>> build({
    required TokenStorage storage,
    required String path,
  }) async {
    final accessToken = await storage.getToken();
    final lang = await AppLocale.getSavedLanguage();
    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept-Language': lang,
    };

    final auth = bearerValue(accessToken);
    if (PmoEndpoints.requiresAuth(path) && auth != null) {
      headers[headerKey] = auth;
    }

    return headers;
  }

  static Future<void> applyStandard(
    RequestOptions options,
    TokenStorage storage,
  ) async {
    final accessToken = await storage.getToken();
    final lang = await AppLocale.getSavedLanguage();

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = lang;

    if (PmoEndpoints.requiresAuth(options.path)) {
      final auth = bearerValue(accessToken);
      if (auth != null) {
        options.headers[headerKey] = auth;
      } else {
        options.headers.remove(headerKey);
      }
    } else {
      options.headers.remove(headerKey);
    }
  }
}
