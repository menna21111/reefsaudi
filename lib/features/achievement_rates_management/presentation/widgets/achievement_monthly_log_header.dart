import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import 'achievement_add_month_button.dart';

class AchievementMonthlyLogHeader extends StatelessWidget {
  final VoidCallback? onAddMonthTap;

  const AchievementMonthlyLogHeader({super.key, this.onAddMonthTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RobotoText(
          text: 'monthly_achievement_log'.tr(),
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.kWhiteColor,
          textAlign: TextAlign.right,
        ),
        AchievementAddMonthButton(onTap: onAddMonthTap),
      ],
    );
  }
}
