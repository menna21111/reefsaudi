import 'package:flutter/material.dart';

abstract class AppColorScheme {
  Color get kPrimaryColor;
  Color get kGoldColor;
  Color get kWhiteColor;
  Color get kBgColor;
  Color get kBlackColor;
  Color get kGrayColor;
  Color get kDarkGrayColor;
  Color get kDarkBlueColor;
  Color get kRedColor;
  Color get kIconColor;
  Color get kBorderColor;
  Color get kInputPrimaryColor;
  Color get kSecondChartGradientColor;
  Color get kFontColor;
  Color get kInputColor;
}


// الألوان حسب الثيم:
//   context.appColors           (extension في app_theme_context.dart)
//   context.watch<ThemeBloc>().state.appColor
//   AppTheme.of(isDark)
//   AppTheme.light / AppTheme.dark