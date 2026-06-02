import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class AchievementLinearProgressRow extends StatelessWidget {
  final String label;
  final String percentText;
  final double value;
  final Color fillColor;

  const AchievementLinearProgressRow({
    super.key,
    required this.label,
    required this.percentText,
    required this.value,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RobotoText(
              text: label,
              fontSize: 11.sp,
              color: AppColor.kGrayTextColor,
              textAlign: TextAlign.right,
            ),
            RobotoText(
              text: percentText,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: fillColor,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6.h,
            backgroundColor: AppColor.kBorderLight,
            valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          ),
        ),
      ],
    );
  }
}
