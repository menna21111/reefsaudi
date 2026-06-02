import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class AchievementPlanGapBadge extends StatelessWidget {
  final String label;

  const AchievementPlanGapBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.kRedColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.kRedColor.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RobotoText(
            text: label,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.kRedColor,
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.arrow_downward_rounded,
            color: AppColor.kRedColor,
            size: 14.sp,
          ),
        ],
      ),
    );
  }
}
