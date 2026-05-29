import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

class AppColor {
  static const Color kPrimaryColor = Color(0xFF10B981);
  static const Color kPrimaryActionColor = Color(0xFF10B981);
  static const Color kBackgroundColor = Color(0xFF10131A);
  static const Color kSurfaceColor = Color(0xFF191C22);
  static const Color kInputBackgroundColor = Color(0xFF10131A);
  static const Color kInputBorderColor = Color(0x1AFFFFFF);
  static const Color kWhiteColor = Color(0xFFFFFFFF);
  static const Color kBlackColor = Color(0xFF000000);
  static const Color kGrayTextColor = Color(0xFF9CA3AF);
  static const Color kSecondaryTextColor = Color(0xFF9CA3AF);
  static const Color kTextFieldBackground = Color(0xFF10131A);
  static const Color kTextFieldBorder = Color(0x1AFFFFFF);
  static const Color kSurfaceContainer = Color(0xFF191C22);
  static const Color kGoldColor = Color(0xFFD0AB52);
  static const Color kRedColor = Color(0xFFEF4444);
  static const Color kBorderColor = Color(0xFF2A2F36);
  static const Color kDarkGrayColor = Color(0xFF4B5563);
  static const Color kDarkBlueColor = Color(0xFF0B3B2D);
  static const Color kFontColor = Color(0xFFFFFFFF);
  static const Color kFont2Color = Color(0xFF9CA3AF);
  static const Color kFillColor = Color(0xFF121825);
  static const Color kGrayColor = Color(0xFF9CA3AF);
  static const Color kIconColor = Color(0xFFFFFFFF);
  static const Color kBgColor = kBackgroundColor;
  static const Color kInputColor = kInputBackgroundColor;
  static const Color kGradientStart = Color(0x2210B981);
  static const Color kGradientEnd = Color(0xFF10131A);
  static const Color kGlowColor = Color(0xFF10B981);
  static const Color kCardSurface = Color(0xFF191C22);
  static const Color kBackdropOverlay = Color(0x3310131A);
  static const Color kBorderLight = Color(0xFF2E3340);

  static const Color kPrimarydarkColor = Color(0xFF0F9D58);
  static const Color kSecondaryColor = Color(0xFF10B981);
  static const Color kPrimaryDarkColor = Color(0xFF0F9D58);
  static const Color kGoldShadowColor = Color(0x33D0AB52);
  static const Color kText2GrayColor = Color(0xFF484848);
  static const Color kborderdisableColor = Color(0xFF545454);
  static const Color kDisabledColor = Color(0xFFA19F9F);
}

class LightAppColor implements AppColorScheme {
  @override
  Color get kPrimaryColor => AppColor.kPrimaryColor;

  @override
  Color get kGoldColor => AppColor.kGoldColor;

  @override
  Color get kWhiteColor => AppColor.kWhiteColor;

  @override
  Color get kBgColor => AppColor.kBackgroundColor;

  @override
  Color get kBlackColor => AppColor.kBlackColor;

  @override
  Color get kGrayColor => AppColor.kGrayColor;

  @override
  Color get kDarkGrayColor => AppColor.kDarkGrayColor;

  @override
  Color get kDarkBlueColor => AppColor.kDarkBlueColor;

  @override
  Color get kRedColor => AppColor.kRedColor;

  @override
  Color get kIconColor => AppColor.kIconColor;

  @override
  Color get kBorderColor => AppColor.kBorderColor;

  @override
  Color get kInputPrimaryColor => AppColor.kPrimaryColor;

  @override
  Color get kSecondChartGradientColor => AppColor.kPrimaryColor;

  @override
  Color get kFontColor => AppColor.kFontColor;
  @override
  Color get kInputColor => AppColor.kInputColor;
}

class DarkAppColor implements AppColorScheme {
  @override
  Color get kPrimaryColor => AppColor.kPrimaryColor;

  @override
  Color get kGoldColor => AppColor.kGoldColor;

  @override
  Color get kWhiteColor => AppColor.kWhiteColor;

  @override
  Color get kBgColor => AppColor.kBackgroundColor;

  @override
  Color get kBlackColor => AppColor.kBlackColor;

  @override
  Color get kGrayColor => AppColor.kGrayColor;

  @override
  Color get kDarkGrayColor => AppColor.kDarkGrayColor;

  @override
  Color get kDarkBlueColor => AppColor.kDarkBlueColor;

  @override
  Color get kRedColor => AppColor.kRedColor;

  @override
  Color get kIconColor => AppColor.kIconColor;

  @override
  Color get kBorderColor => AppColor.kBorderColor;

  @override
  Color get kInputPrimaryColor => AppColor.kPrimaryColor;

  @override
  Color get kSecondChartGradientColor => AppColor.kPrimaryColor;

  @override
  Color get kFontColor => AppColor.kFontColor;
  @override
  Color get kInputColor => AppColor.kInputColor;
}
