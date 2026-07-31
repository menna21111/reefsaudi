import 'package:flutter/material.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_theme_context.dart';

/// Theme-aware palette for the Fahim chat UI (follows app light/dark).
class AppColors {
  AppColors._(this._colors);

  factory AppColors.of(BuildContext context) =>
      AppColors._(context.appColors);

  final AppColorScheme _colors;

  Color get primaryNavy => _colors.kBgColor;
  Color get secondaryNavy => _colors.kInputColor;
  Color get accentGold => _colors.kGoldColor;
  Color get electricTeal => _colors.kPrimaryColor;
  Color get slateGrey => _colors.kGrayColor;
  Color get offWhite => _colors.kFontColor;
  Color get red => _colors.kRedColor;
  Color get border => _colors.kBorderColor;

  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      _colors.kBgColor,
      Color.lerp(_colors.kBgColor, _colors.kInputColor, 0.85) ??
          _colors.kInputColor,
    ],
  );

  LinearGradient get orbGradient => LinearGradient(
    colors: [
      _colors.kPrimaryColor,
      Color.lerp(_colors.kPrimaryColor, _colors.kGoldColor, 0.35) ??
          _colors.kPrimaryColor,
    ],
  );
}
