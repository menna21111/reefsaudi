/// Holds the base URL set at app startup by main_dev or main_prod.
String? _baseUrl;

/// Holds the WebSocket base URL set at app startup.
String? _webSocketBaseUrl;

/// When true, backend auth is disabled; app uses guest identity and skips /auth/* calls.
bool _useTrustedServiceMode = false;

/// Default production endpoints for Fahim chat agent.
const String kDefaultChatBaseUrl = 'https://pmoapi.almanzoor.net/api/';
const String kDefaultChatWebSocketUrl = 'wss://aiagent.almanzoor.net';

void setBaseUrl(String url) {
  _baseUrl = url;
}

void setWebSocketBaseUrl(String url) {
  _webSocketBaseUrl = url;
}

/// Idempotent bootstrap so chat can open even if main forgot to configure.
void ensureChatConfig({
  String baseUrl = kDefaultChatBaseUrl,
  String webSocketUrl = kDefaultChatWebSocketUrl,
}) {
  if (_baseUrl == null || _baseUrl!.isEmpty) {
    _baseUrl = baseUrl;
  }
  if (_webSocketBaseUrl == null || _webSocketBaseUrl!.isEmpty) {
    _webSocketBaseUrl = webSocketUrl;
  }
}

void setTrustedServiceMode({required bool value}) {
  _useTrustedServiceMode = value;
}

bool get useTrustedServiceMode => _useTrustedServiceMode;

/// The Angular portal origin for SSO postMessage validation.
/// Must match the Angular frontend URL (NOT the backend API URL).
String? _portalOrigin;

void setPortalOrigin(String origin) {
  _portalOrigin = origin;
}

String get portalOrigin {
  final origin = _portalOrigin;
  if (origin == null || origin.isEmpty) {
    throw StateError(
      'Portal origin not set. '
      'Call setPortalOrigin() before SSO handshake.',
    );
  }
  return origin;
}

String get baseUrl {
  final url = _baseUrl;
  if (url == null || url.isEmpty) {
    throw StateError(
      'Base URL not set. Ensure main_dev.dart or main_prod.dart is used.',
    );
  }
  return url;
}

/// Returns the dedicated WebSocket base URL.
/// Falls back to deriving from [baseUrl] if not explicitly set.
String? get webSocketBaseUrl => _webSocketBaseUrl;
