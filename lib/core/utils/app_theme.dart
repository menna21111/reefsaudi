import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_color.dart';

class AppTheme {
  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Almarai',
    scaffoldBackgroundColor: AppColor.kBackgroundColor,
    canvasColor: AppColor.kBackgroundColor,
    cardColor: AppColor.kCardSurface,
    dialogBackgroundColor: AppColor.kCardSurface,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.kBackgroundColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColor.kWhiteColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColor.kWhiteColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.kPrimaryColor,
        foregroundColor: AppColor.kWhiteColor,
        shadowColor: AppColor.kGlowColor.withOpacity(0.35),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.kInputBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColor.kInputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColor.kInputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColor.kPrimaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColor.kGrayTextColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColor.kWhiteColor),
      displayMedium: TextStyle(color: AppColor.kWhiteColor),
      displaySmall: TextStyle(color: AppColor.kWhiteColor),
      headlineLarge: TextStyle(
        color: AppColor.kWhiteColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColor.kWhiteColor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: AppColor.kWhiteColor),
      bodyMedium: TextStyle(color: AppColor.kGrayTextColor),
      bodySmall: TextStyle(color: AppColor.kGrayTextColor),
      labelLarge: TextStyle(color: AppColor.kPrimaryColor),
      labelMedium: TextStyle(color: AppColor.kPrimaryColor),
    ),
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColor.kPrimaryColor,
      onPrimary: AppColor.kWhiteColor,
      secondary: AppColor.kPrimaryColor,
      onSecondary: AppColor.kWhiteColor,
      surface: AppColor.kCardSurface,
      onSurface: AppColor.kWhiteColor,
      error: AppColor.kRedColor,
      onError: AppColor.kWhiteColor,
    ),
    iconTheme: const IconThemeData(color: AppColor.kWhiteColor),
    dividerColor: AppColor.kBorderLight,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColor.kCardSurface,
      contentTextStyle: TextStyle(color: AppColor.kWhiteColor),
    ),
  );

  // Light Theme (أبيض مع أخضر)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Almarai',
    scaffoldBackgroundColor: AppColor.kLightBackgroundColor,
    canvasColor: AppColor.kLightBackgroundColor,
    cardColor: AppColor.kLightCardSurface,
    dialogBackgroundColor: AppColor.kLightCardSurface,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.kLightBackgroundColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColor.kLightTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColor.kLightTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.kPrimaryColor,
        foregroundColor: AppColor.kWhiteColor,
        shadowColor: AppColor.kPrimaryColor.withOpacity(0.25),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.kLightInputBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColor.kLightInputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColor.kLightInputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColor.kPrimaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColor.kLightSecondaryTextColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColor.kLightTextColor),
      displayMedium: TextStyle(color: AppColor.kLightTextColor),
      displaySmall: TextStyle(color: AppColor.kLightTextColor),
      headlineLarge: TextStyle(
        color: AppColor.kLightTextColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColor.kLightTextColor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: AppColor.kLightTextColor),
      bodyMedium: TextStyle(color: AppColor.kLightSecondaryTextColor),
      bodySmall: TextStyle(color: AppColor.kLightSecondaryTextColor),
      labelLarge: TextStyle(color: AppColor.kPrimaryColor),
      labelMedium: TextStyle(color: AppColor.kPrimaryColor),
    ),
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.kPrimaryColor,
      onPrimary: AppColor.kWhiteColor,
      secondary: AppColor.kPrimaryColor,
      onSecondary: AppColor.kWhiteColor,
      surface: AppColor.kLightCardSurface,
      onSurface: AppColor.kLightTextColor,
      error: AppColor.kRedColor,
      onError: AppColor.kWhiteColor,
    ),
    iconTheme: const IconThemeData(color: AppColor.kLightTextColor),
    dividerColor: AppColor.kLightBorderColor,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColor.kLightCardSurface,
      contentTextStyle: TextStyle(color: AppColor.kLightTextColor),
    ),
  );
}
