import 'package:shared_preferences/shared_preferences.dart';

class UserSessionManager {
  static const String _userPhoneKey = 'user_phone';
  static const String _isGuestKey = 'is_guest';

  // Set current user phone
  static Future<void> setUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPhoneKey, phone);
    await prefs.setBool(_isGuestKey, _isGuestPhone(phone));
  }

  // Get current user phone
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneKey);
  }

  // Check if current user is guest
  static Future<bool> isGuestUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isGuestKey) ?? false;
  }

  // Clear user session
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_isGuestKey);
  }

  // Check if phone number is guest
  static bool _isGuestPhone(String phone) {
    return phone == "123456789" || phone == "visitor";
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
}
