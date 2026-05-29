import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_color.dart';

class AppTheme {
  static final ThemeData baseTheme = ThemeData(
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
          fontFamily: 'Pupsymal',
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
        borderSide: BorderSide(color: AppColor.kInputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.kInputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColor.kPrimaryColor),
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
      background: AppColor.kBackgroundColor,
      onBackground: AppColor.kWhiteColor,
      surface: AppColor.kCardSurface,
      onSurface: AppColor.kWhiteColor,
      error: AppColor.kRedColor,
      onError: AppColor.kWhiteColor,
    ),
    iconTheme: const IconThemeData(color: AppColor.kWhiteColor),
    dividerColor: AppColor.kBorderLight,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.kCardSurface,
      contentTextStyle: const TextStyle(color: AppColor.kWhiteColor),
    ),
  );

  static ThemeData lightTheme = baseTheme;
  static ThemeData darkTheme = baseTheme;
}
