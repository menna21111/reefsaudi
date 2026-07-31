import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';

class QualityRequestDetailField extends StatelessWidget {
  const QualityRequestDetailField({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  static String display(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? '-' : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 11.sp,
              fontFamily: 'Almarai',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
              fontFamily: 'Almarai',
            ),
          ),
        ],
      ),
    );
  }
}
