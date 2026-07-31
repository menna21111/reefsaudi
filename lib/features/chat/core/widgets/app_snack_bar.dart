import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

/// Theme-aware reusable SnackBar for chat.
enum AppSnackBarType { success, error, info }

class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = AppColors.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: colors.offWhite),
          textAlign: TextAlign.right,
        ),
        duration: duration,
        backgroundColor: colors.secondaryNavy,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: switch (type) {
              AppSnackBarType.success => colors.electricTeal,
              AppSnackBarType.error => Colors.redAccent.withValues(alpha: 0.8),
              AppSnackBarType.info => colors.slateGrey.withValues(alpha: 0.5),
            },
          ),
        ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) => show(
    context,
    message: message,
    type: AppSnackBarType.success,
    duration: duration ?? const Duration(seconds: 3),
  );

  static void showError(BuildContext context, String message) =>
      show(context, message: message, type: AppSnackBarType.error);

  static void showInfo(BuildContext context, String message) =>
      show(context, message: message);
}
