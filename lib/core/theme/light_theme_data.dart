import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_theme.dart';

final ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'Almarai',
  scaffoldBackgroundColor: AppTheme.light.kBgColor,
  canvasColor: AppTheme.light.kBgColor,
  cardColor: AppColor.kLightCardSurface,
  dialogTheme: DialogThemeData(
    backgroundColor: AppColor.kLightCardSurface,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppTheme.light.kBgColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppTheme.light.kFontColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppTheme.light.kIconColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.light.kPrimaryColor,
      foregroundColor: AppColor.kWhiteColor,
      shadowColor: AppTheme.light.kPrimaryColor.withValues(alpha: 0.25),
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
    fillColor: AppTheme.light.kInputColor,
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColor.kLightInputBorderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColor.kLightInputBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppTheme.light.kPrimaryColor, width: 2),
    ),
    hintStyle: TextStyle(color: AppTheme.light.kGrayColor),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: AppTheme.light.kFontColor),
    displayMedium: TextStyle(color: AppTheme.light.kFontColor),
    displaySmall: TextStyle(color: AppTheme.light.kFontColor),
    headlineLarge: TextStyle(
      color: AppTheme.light.kFontColor,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: AppTheme.light.kFontColor,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(color: AppTheme.light.kFontColor),
    bodyMedium: TextStyle(color: AppTheme.light.kGrayColor),
    bodySmall: TextStyle(color: AppTheme.light.kGrayColor),
    labelLarge: TextStyle(color: AppTheme.light.kPrimaryColor),
    labelMedium: TextStyle(color: AppTheme.light.kPrimaryColor),
  ),
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: AppTheme.light.kPrimaryColor,
    onPrimary: AppColor.kWhiteColor,
    secondary: AppTheme.light.kPrimaryColor,
    onSecondary: AppColor.kWhiteColor,
    surface: AppColor.kLightCardSurface,
    onSurface: AppTheme.light.kFontColor,
    error: AppTheme.light.kRedColor,
    onError: AppColor.kWhiteColor,
  ),
  iconTheme: IconThemeData(color: AppTheme.light.kIconColor),
  dividerColor: AppTheme.light.kBorderColor,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColor.kLightCardSurface,
    contentTextStyle: TextStyle(color: AppTheme.light.kFontColor),
  ),
);
