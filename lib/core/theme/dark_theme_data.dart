import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_theme.dart';

final ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'Almarai',
  scaffoldBackgroundColor: AppTheme.dark.kBgColor,
  canvasColor: AppTheme.dark.kBgColor,
  cardColor: AppColor.kCardSurface,
  dialogTheme: DialogThemeData(
    backgroundColor: AppColor.kCardSurface,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppTheme.dark.kBgColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppTheme.dark.kFontColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppTheme.dark.kIconColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.dark.kPrimaryColor,
      foregroundColor: AppColor.kWhiteColor,
      shadowColor: AppColor.kGlowColor.withValues(alpha: 0.35),
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
    fillColor: AppTheme.dark.kInputColor,
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
      borderSide: BorderSide(color: AppTheme.dark.kPrimaryColor, width: 2),
    ),
    hintStyle: TextStyle(color: AppTheme.dark.kGrayColor),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: AppTheme.dark.kFontColor),
    displayMedium: TextStyle(color: AppTheme.dark.kFontColor),
    displaySmall: TextStyle(color: AppTheme.dark.kFontColor),
    headlineLarge: TextStyle(
      color: AppTheme.dark.kFontColor,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: AppTheme.dark.kFontColor,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(color: AppTheme.dark.kFontColor),
    bodyMedium: TextStyle(color: AppTheme.dark.kGrayColor),
    bodySmall: TextStyle(color: AppTheme.dark.kGrayColor),
    labelLarge: TextStyle(color: AppTheme.dark.kPrimaryColor),
    labelMedium: TextStyle(color: AppTheme.dark.kPrimaryColor),
  ),
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppTheme.dark.kPrimaryColor,
    onPrimary: AppColor.kWhiteColor,
    secondary: AppTheme.dark.kPrimaryColor,
    onSecondary: AppColor.kWhiteColor,
    surface: AppColor.kCardSurface,
    onSurface: AppTheme.dark.kFontColor,
    error: AppTheme.dark.kRedColor,
    onError: AppColor.kWhiteColor,
  ),
  iconTheme: IconThemeData(color: AppTheme.dark.kIconColor),
  dividerColor: AppTheme.dark.kBorderColor,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColor.kCardSurface,
    contentTextStyle: TextStyle(color: AppTheme.dark.kFontColor),
  ),
);
