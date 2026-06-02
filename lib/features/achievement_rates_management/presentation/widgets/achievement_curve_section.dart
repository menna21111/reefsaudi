import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import 'achievement_curve_chart.dart';

class AchievementCurveSection extends StatelessWidget {
  const AchievementCurveSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RobotoText(
          text: 'achievement_curve'.tr(),
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.kWhiteColor,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.kSurfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColor.kBorderColor.withOpacity(0.3),
            ),
          ),
          child: const AchievementCurveChart(),
        ),
      ],
    );
  }
}
