import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';

abstract final class StatisticsStyle {
  static TextStyle title(BuildContext context) {
    final colors = context.appColors;
    return TextStyle(
      fontFamily: 'Almarai',
      color: colors.kFontColor,
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle label(
    BuildContext context, {
    Color? color,
    double size = 12,
    FontWeight weight = FontWeight.w500,
  }) {
    final colors = context.appColors;
    return TextStyle(
      fontFamily: 'Almarai',
      color: color ?? colors.kGrayColor,
      fontSize: size.sp,
      fontWeight: weight,
    );
  }

  static TextStyle value(
    BuildContext context, {
    required Color color,
    double size = 15,
  }) {
    return TextStyle(
      fontFamily: 'Almarai',
      color: color,
      fontSize: size.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static Color textOnAccent = Colors.white;

  static Color statusFinished(AppColorScheme colors) {
    return Color.lerp(colors.kPrimaryColor, colors.kDarkBlueColor, 0.4) ??
        colors.kDarkBlueColor;
  }

  static List<Color> sectorBarColors(AppColorScheme colors) => [
        colors.kPrimaryColor.withValues(alpha: 0.85),
        colors.kGoldColor.withValues(alpha: 0.9),
      ];

  static List<Color> piePalette(AppColorScheme colors) => [
        colors.kPrimaryColor,
        statusFinished(colors),
        colors.kGoldColor,
        colors.kDarkGrayColor,
        colors.kPrimaryColor.withValues(alpha: 0.65),
        colors.kGoldColor.withValues(alpha: 0.75),
        colors.kRedColor,
      ];

  static List<Color> qcPalette(AppColorScheme colors) => [
        colors.kGoldColor.withValues(alpha: 0.85),
        colors.kPrimaryColor,
        statusFinished(colors),
      ];

  static String localizeQcCategory(String category) {
    final normalized = category.trim();
    switch (normalized) {
      case 'تحت الدراسة':
        return AppString.qcCategoryUnderStudy.tr();
      case 'يعاد التسليم':
        return AppString.qcCategoryResubmission.tr();
      case 'معتمد':
        return AppString.qcCategoryApproved.tr();
      default:
        return category;
    }
  }
}
