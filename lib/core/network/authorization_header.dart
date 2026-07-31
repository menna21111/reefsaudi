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

  static String requestPath(RequestOptions options) {
    final uriPath = options.uri.path;
    if (uriPath.isNotEmpty && uriPath != '/') {
      return uriPath;
    }
    return options.path;
  }

  static Future<Map<String, dynamic>> build({
    required TokenStorage storage,
    required String path,
    bool includeAuth = true,
  }) async {
    final lang = await AppLocale.getSavedLanguage();
    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept-Language': lang,
    };

    if (!includeAuth || PmoEndpoints.isPublicAuthPath(path)) {
      return headers;
    }

    final auth = bearerValue(await storage.getToken());
    if (auth != null) {
      headers[headerKey] = auth;
    }

    return headers;
  }

  static Future<void> applyStandard(
    RequestOptions options,
    TokenStorage storage,
  ) async {
    final path = requestPath(options);
    final lang = await AppLocale.getSavedLanguage();
    final method = options.method.toUpperCase();

    if (method == 'POST' || method == 'PUT' || method == 'PATCH') {
      options.headers['Content-Type'] = 'application/json';
    } else {
      options.headers.remove('Content-Type');
    }
    options.headers['Accept-Language'] = lang;
    options.headers['Accept'] = 'application/json';
    options.headers.remove(headerKey);

    if (PmoEndpoints.isPublicAuthPath(path)) {
      return;
    }

    final auth = bearerValue(await storage.getToken());
    if (auth != null) {
      options.headers[headerKey] = auth;
    }
  }
}
