import 'package:flutter/material.dart';

import '../error/exceptions.dart';
import '../services/service_locator.dart';
import '../services/token_service/token_storage.dart';


class AuthErrorHandler {
  static bool _isHandlingAuthError = false;

  static void handleAuthenticationError(BuildContext context) {
    if (_isHandlingAuthError) {
      // Already handling an auth error, do nothing
      return;
    }

    _isHandlingAuthError = true;

    // Clear token
    sl<TokenStorage>().clearToken();

    // Navigate to login screen
    // if (context.mounted) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => LoginScreen(),
    //     ),
    //     (Route<dynamic> route) => false,
    //   );
    // }

    Future.delayed(const Duration(seconds: 5), () {
      _isHandlingAuthError = false;
    });
  }

  static bool isAuthError(dynamic error) {
    if (error is UnAuthenticatedException) {
      return true;
    }

    if (error is String) {
      return error.contains("Unauthorized") ||
          error.contains("Session expired") ||
          error.contains("UnAuthenticatedException");
    }

    return false;
  }
}
