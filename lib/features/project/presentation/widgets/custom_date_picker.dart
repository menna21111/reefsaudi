import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final String dateText;
  final VoidCallback onTap;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colors.kBorderColor, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.date_range, color: colors.kPrimaryColor, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  dateText,
                  style: TextStyle(color: colors.kFontColor, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
