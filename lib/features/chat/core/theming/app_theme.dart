import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

/// Optional chat-scoped theme that follows the host app light/dark palette.
ThemeData buildAppTheme(BuildContext context) {
  final colors = AppColors.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final base = isDark ? ThemeData.dark() : ThemeData.light();
  final colorScheme = base.colorScheme.copyWith(
    primary: colors.accentGold,
    secondary: colors.electricTeal,
    surface: colors.secondaryNavy,
    onPrimary: colors.primaryNavy,
    onSecondary: colors.primaryNavy,
    onSurface: colors.offWhite,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'Tajawal'),
    primaryTextTheme: base.primaryTextTheme.apply(fontFamily: 'Tajawal'),
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.primaryNavy,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.primaryNavy,
      foregroundColor: colors.offWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: colors.offWhite,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.secondaryNavy,
      labelStyle: TextStyle(color: colors.slateGrey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.slateGrey.withValues(alpha: 0.4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.electricTeal, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.red.withValues(alpha: 0.9)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.red.withValues(alpha: 0.9),
          width: 1.6,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.electricTeal,
        foregroundColor: colors.primaryNavy,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.slateGrey,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    cardColor: colors.secondaryNavy,
    cardTheme: CardThemeData(
      color: colors.secondaryNavy,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.slateGrey,
        side: BorderSide(color: colors.slateGrey.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),
  );
}
