import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class ProjectDetailField extends StatelessWidget {
  const ProjectDetailField({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.kBgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.kBorderColor.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: valueColor ?? colors.kFontColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Almarai',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectDetailFieldGap extends StatelessWidget {
  const ProjectDetailFieldGap({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: 10.h);
}
