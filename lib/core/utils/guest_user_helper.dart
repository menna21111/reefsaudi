class GuestUserHelper {
  static const String guestPhone = "123456789";
  static const String guestPassword = "123456789";
  static const String guestName = "visitor";

  // Check if current user is a guest
  static bool isGuestUser(String? phone) {
    return phone == guestPhone || phone == guestName;
  }

  // Check if feature requires authentication
  static bool requiresAuth(String feature) {
    List<String> guestAllowedFeatures = [
      'home',
      'restaurant_details',
      'product_details',
      'categories',
      'browse_products',
    ];

    return !guestAllowedFeatures.contains(feature);
  }

  // Get guest login message
  static String getGuestLoginMessage() {
    return "هذه الميزة تتطلب تسجيل دخول. يرجى إنشاء حساب أو تسجيل الدخول للوصول إلى هذه الميزة.";
  }

  // Get guest login title
  static String getGuestLoginTitle() {
    return "تسجيل الدخول مطلوب";
  }

}
