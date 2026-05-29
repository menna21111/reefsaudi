class ApiConstants {
  // static const String _prodBaseUrl = "https://qaribapp.com/";
  static const String _devBaseUrl = "https://api.mandoobexpress.com/api/v1/";
  static const String domain = "https://api.mandoobexpress.com/api/v1/";

  // // Default to prod, but will be overridden by Remote Config
  // // Set to true by default here IF you want local dev to be default without config
  // static bool _useDevServer = true;

  // static set useDevServer(bool value) {
  //   _useDevServer = value;
  // }

  static String get baseUrl => _devBaseUrl;
  // _useDevServer ?

  // : _prodBaseUrl;

  // Backward compatibility: places using devbaseUrl should now use the dynamic baseUrl
  static String get devbaseUrl => baseUrl;

  static String get imageproductUrl => "${baseUrl}uploads/productimages/";
  static String get imageofferUrl => "$baseUrl/uploads/offers/";
  static String get resturantimageUrl => "${baseUrl}uploads/resturantimage/";
  static String get storeimageUrl => "${baseUrl}uploads/storeimage/";
  static String get customerImageUrl => "${baseUrl}uploads/imageProfile/";
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
}
