import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';

InputDecoration createQualityInputDecoration(
  BuildContext context,
  String label,
) {
  final colors = context.appColorsRead;
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      fontFamily: 'Almarai',
      color: colors.kGrayColor,
    ),
    filled: true,
    fillColor: colors.kInputColor,
    alignLabelWithHint: true,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(
        color: colors.kBorderColor.withValues(alpha: 0.45),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: colors.kPrimaryColor, width: 1.5),
    ),
  );
}
