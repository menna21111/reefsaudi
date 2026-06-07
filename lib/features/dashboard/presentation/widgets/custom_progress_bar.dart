import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color.dart';

class CustomProgressBar extends StatelessWidget {
  final String label;
  final String percentageText;
  final double percentage;
  final Color color;
  final Color? backgroundColor;
  final Color? labelColor;

  const CustomProgressBar({
    super.key,
    required this.label,
    required this.percentageText,
    required this.percentage,
    required this.color,
    this.backgroundColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = labelColor ?? AppColor.kGrayTextColor;
    final trackColor = backgroundColor ?? AppColor.kBorderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: textColor, fontSize: 12.sp),
              ),
            ),
            Text(
              percentageText,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: trackColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }
}
