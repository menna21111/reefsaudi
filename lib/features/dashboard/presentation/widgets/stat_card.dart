import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_theme_context.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final Color? borderColor;
  final Color? color;
  final bool showBottomLine;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.borderColor,
    this.color,
    this.showBottomLine = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = valueColor ?? color ?? colors.kWhiteColor;

    return Container(
      margin: EdgeInsets.only(right: borderColor != null ? 4.w : 0),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: borderColor != null
            ? Border(right: BorderSide(color: borderColor!, width: 4.w))
            : Border.all(color: colors.kBorderColor.withOpacity(0.25)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: RobotoText(
                  text: title,
                  color: colors.kGrayColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (icon != null)
                Icon(icon, color: accent.withOpacity(0.85), size: 18.sp),
            ],
          ),
          SizedBox(height: 8.h),
          RobotoText(
            text: value,
            color: accent,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          if (showBottomLine) ...[
            SizedBox(height: 10.h),
            Container(
              height: 3.h,
              width: 36.w,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
