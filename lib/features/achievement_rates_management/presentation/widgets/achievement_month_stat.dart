import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class AchievementMonthStat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const AchievementMonthStat({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RobotoText(
          text: label,
          fontSize: 9.sp,
          color: AppColor.kGrayTextColor,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 2.h),
        RobotoText(
          text: value,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: valueColor,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
