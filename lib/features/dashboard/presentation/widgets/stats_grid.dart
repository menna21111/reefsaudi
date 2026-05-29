import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: AppString.totalProjects.tr(),
                value: '108',
                valueColor: AppColor.kPrimaryColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: AppString.underExecution.tr(),
                value: '64',
                borderColor: AppColor.kPrimaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: StatCard(title: AppString.totalBudget.tr(), value: '94M'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: AppString.delayed.tr(),
                value: '12',
                valueColor: AppColor.kGoldColor,
                borderColor: AppColor.kGoldColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
