class PmoEndpoints {
  static const String login = 'account/login';
  static const String account = 'account';
  static const String projectSearch = 'project/search';

  /// Paths that must not send a stored Bearer token (e.g. expired token → 401).
  static const _publicPaths = [login];

  static bool requiresAuth(String path) {
    final normalized = path.toLowerCase();
    return !_publicPaths.any(normalized.endsWith);
  }
}
