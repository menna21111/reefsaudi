import 'package:reefsaudia/features/chat/core/config/app_config.dart';
import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

class UrlProvider {
  static final AppLogger _logger = AppLogger();

  /// HTTP base URL for REST API (same domain as WebSocket, http/https).
  static String get httpBaseUrl {
    final rawUrl = baseUrl.trim();
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl.split('#').first.split('?').first.trim();
    }
    final cleanUrl = rawUrl
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .split('#')
        .first
        .split('?')
        .first
        .trim();
    // Bare domain (no protocol): use https for known remote hosts
    if (cleanUrl.contains('ngrok') ||
        cleanUrl.contains('railway') ||
        cleanUrl.contains('render') ||
        cleanUrl.contains('almanzoor')) {
      return 'https://$cleanUrl';
    }
    return 'http://$cleanUrl';
  }

  static String get webSocketUrl {
    if (kIsWeb) {
      // WEB ONLY: Dynamically grab the domain the browser is currently on.
      // This forces the traffic to go through your IIS Proxy rule.
      final currentUri = Uri.base;
      final scheme = currentUri.scheme == 'https' ? 'wss' : 'ws';

      // If running on a standard port (80/443), omit the port. Otherwise, include it.
      final portString = (currentUri.port == 80 || currentUri.port == 443)
          ? ''
          : ':${currentUri.port}';

      final url = '$scheme://${currentUri.host}$portString/ws';
      _logger.i('🔗 Constructed Web WebSocket URL: $url');
      return url;
    } else {
      // MOBILE ONLY: Use dedicated WebSocket URL if set, otherwise derive
      // from the REST baseUrl.
      final wsBase = webSocketBaseUrl;
      if (wsBase != null && wsBase.isNotEmpty) {
        // Dedicated WebSocket URL provided (e.g. wss://aiagent.almanzoor.net)
        final trimmed = wsBase.trim();
        final url = trimmed.endsWith('/ws') ? trimmed : '$trimmed/ws';
        _logger.i('🔗 Using dedicated Mobile WebSocket URL: $url');
        return url;
      }

      final rawUrl = baseUrl.trim();
      final cleanUrl = rawUrl
          .replaceAll('https://', '')
          .replaceAll('http://', '')
          .split('#')
          .first
          .split('?')
          .first
          .trim();

      // If original URL was explicit http://, use ws://, otherwise wss://
      final scheme = rawUrl.startsWith('http://') ? 'ws' : 'wss';

      final url = '$scheme://$cleanUrl/ws';
      _logger.i('🔗 Constructed Mobile WebSocket URL: $url');
      return url;
    }
  }

  /// WebSocket URL with optional user identity for Trusted Service backend
  /// (query params: user_id, user_name).
  /// If both [userId] and [userName] are null, returns [webSocketUrl]
  /// with no query params.
  static String webSocketUrlWithUser({String? userId, String? userName}) {
    final base = webSocketUrl;
    if (userId == null && userName == null) {
      return base;
    }
    final id = Uri.encodeComponent(userId ?? 'guest');
    final name = Uri.encodeComponent(userName ?? 'User');
    final separator = base.contains('?') ? '&' : '?';
    final url = '$base${separator}user_id=$id&user_name=$name';
    _logger.i('🔗 WebSocket URL with user: $url');
    return url;
  }
}
