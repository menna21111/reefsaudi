import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';

class CreateQualityReadOnlyField extends StatelessWidget {
  const CreateQualityReadOnlyField({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 12.sp,
              fontFamily: 'Almarai',
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Almarai',
            ),
          ),
        ],
      ),
    );
  }
}
