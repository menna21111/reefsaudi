class ApiConstants {
  static const String pmoBaseUrl = 'https://pmoapi.almanzoor.net/api/';
  // static const String reefBaseUrl = 'https://apiour.mohamedelsayed.site/api/';
  static const String domain = pmoBaseUrl;

  // TODO: Remove temporary token after auth integration.
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
