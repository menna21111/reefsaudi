/// Phone number validation (Yemen format: 9 digits after country code)
String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your phone number';
  }
  final digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 9) {
    return 'Phone number is not valid';
  }
  return null;
}

/// Email validation
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Please enter a valid email';
  }
  return null;
}

/// Password validation
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password is not valid';
  }
  return null;
}
