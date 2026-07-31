class ApiConstants {
  static const String pmoBaseUrl = 'https://pmoapi.almanzoor.net/api/';
  // static const String reefBaseUrl = 'https://pmoapi.almanzoor.net/api/';
      static const String reefBaseUrl = 'https://apiour.mohamedelsayed.site/api/';

  static const String domain = pmoBaseUrl;

  static const String tempAccessToken =
      'eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwidHlwIjoiSldUIiwiY3R5IjoiSldUIn0..nUHlJ34z6mP3dHSN9Hf8sw.iT3W-6JToz6pTz4bhs52SQ0YNMJWPFGDNeZOWqjNsDmTblfmARrMrR9QuzymhiojL52P7h5BBvkCczoHmlvc9oi78MDcaZMVjvVFDa6qSCHI_t8C_HayjmW0KMJ1B4T0DVCE-PFytbDzCyUV90ieMH53vuC6ZFyG2n_Vv1iJnrqSdnf7IvE7Uy3HR07Ibge7z9FQ5lOwHncaZ2c4gugTpsIoI-TnMGyzx8BMXbsKysDl0N5q4XmkEFZceAzy61zKKD-V5lSygUfMvxjTxvhF34wfBdaHpwmeyO5veA7gLaxRTFvz30pRX99w5rY9ALySEYX6GsOCjJ0xp9ZkgYtE7oC-BDxvsBrcgLJL3rA-jSQ9AEa7Mu19pF9Sv7u0uLpg-DaN6mbdHGlyA8j3lrtBDzobI888egK5TXj_ack6VBjwZ7D9Z-6f6dE-mF0h99N2w0ynlAsnVYRjEZgZ-bG41c94MPCkB905hDJquDlUb0VuWdk9fbc4KFrGQC1fX5fe.K0lr8x6F4GxvTg7JcoqaVQ';

  // // Default to prod, but will be overridden by Remote Config
  // // Set to true by default here IF you want local dev to be default without config
  // static bool _useDevServer = true;

  // static set useDevServer(bool value) {
  //   _useDevServer = value;
  // }

  static String get baseUrl => pmoBaseUrl;

  static String get devbaseUrl => baseUrl;

  static String get imageproductUrl => "${baseUrl}uploads/productimages/";
  static String get imageofferUrl => "$baseUrl/uploads/offers/";
  static String get resturantimageUrl => "${baseUrl}uploads/resturantimage/";
  static String get storeimageUrl => "${baseUrl}uploads/storeimage/";
  static String get customerImageUrl => "${baseUrl}uploads/imageProfile/";

  static const String projectMediaBaseUrl =
      'https://apiour.mohamedelsayed.site/api/media/';

  /// Keeps the full JWE access token (HEADER..IV.CIPHERTEXT.TAG) unchanged.
  static String? normalizeJweAccessToken(String? token) {
    if (token == null) return null;

    var value = token.trim();
    if (value.isEmpty) return null;

    const bearerPrefix = 'Bearer ';
    if (value.startsWith(bearerPrefix)) {
      value = value.substring(bearerPrefix.length).trim();
    }

    return value.isEmpty ? null : value;
  }

  /// JWE with alg=dir: `eyJ...` + `..` + IV + ciphertext + tag → 5 dot segments.
  static int jweTokenPartCount(String token) => token.split('.').length;

  static bool jweTokenStartsWithHeader(String token) => token.startsWith('eyJ');

  /// `imageUrl` from API + base + full JWE token (raw, not encoded).
  static String? resolveProjectImageUrl(
    String? imageUrl, {
    String? token,
  }) {
    if (imageUrl == null || imageUrl.trim().isEmpty) return null;

    final trimmed = imageUrl.trim();
    final jweToken = normalizeJweAccessToken(token);

    if (trimmed.startsWith('http')) {
      if (jweToken == null || trimmed.contains('token=')) return trimmed;
      final separator = trimmed.contains('?') ? '&' : '?';
      return '$trimmed${separator}token=$jweToken';
    }

    final path = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    final url = '$projectMediaBaseUrl$path';
    if (jweToken == null) return url;

    // String concat only — preserves `..` in JWE (empty encrypted key for alg=dir).
    return '$url?token=$jweToken';
  }

  /// Builds a full URL for profile/media paths returned by the PMO API.
  /// Format: `{base}{path}?token={jwe}`
  static String? resolveProfilePictureUrl(
    String? path, {
    String? token,
  }) {
    if (path == null || path.trim().isEmpty) return null;

    final trimmed = path.trim();
    final jweToken = normalizeJweAccessToken(token);

    if (trimmed.startsWith('http')) {
      if (jweToken == null || trimmed.contains('token=')) return trimmed;
      final separator = trimmed.contains('?') ? '&' : '?';
      return '$trimmed${separator}token=$jweToken';
    }

    final normalized =
        trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    final url = '$projectMediaBaseUrl$normalized';
    if (jweToken == null) return url;

    return '$url?token=$jweToken';
  }

  /// Task-detail attachment images only: force `/api/media/{path}?token=...`
  /// even when the API returns a full URL without `/media/`.
  static String? resolveAttachmentMediaUrl(
    String? path, {
    String? token,
  }) {
    if (path == null) return null;
    var trimmed = path.trim().replaceAll('\\', '/');
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri != null &&
        uri.hasScheme &&
        (uri.isScheme('http') || uri.isScheme('https'))) {
      trimmed = uri.path;
    }

    if (trimmed.startsWith('/')) trimmed = trimmed.substring(1);

    const prefixes = <String>['api/media/', 'media/', 'api/'];
    for (final prefix in prefixes) {
      if (trimmed.toLowerCase().startsWith(prefix)) {
        trimmed = trimmed.substring(prefix.length);
        break;
      }
    }
    if (trimmed.isEmpty) return null;

    final jweToken = normalizeJweAccessToken(token);
    final url = '$projectMediaBaseUrl$trimmed';
    if (jweToken == null) return url;
    return '$url?token=$jweToken';
  }
  static String get sliderImageUrl => "${baseUrl}uploads/sliderimage/";
  static String get categoryImageUrl => "${baseUrl}uploads/categoryimage/";
  static String get logosImageUrl => "${baseUrl}uploads/logos/";

  // static const String visitorUrl = "visitor1@gmail.com";

  //Auth
  static String get loginUrl => "collector/login";
  static String get forgotPasswordUrl => "collector/forgot-password";
  static String get verifyOtpUrl => "collector/verify-otp";
  static String get resendOtpUrl => "collector/resend-otp";
  static String get resetPasswordUrl => "collector/reset-password";

  static String get financialStatementUrl =>
      '${baseUrl}FinancialStatement';
}
