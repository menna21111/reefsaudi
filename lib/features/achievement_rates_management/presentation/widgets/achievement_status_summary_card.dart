import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/models/achievement_month_record.dart';
import 'achievement_linear_progress_row.dart';
import 'achievement_plan_gap_badge.dart';

class AchievementStatusSummaryCard extends StatelessWidget {
  const AchievementStatusSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final status = achievementCurrentStatus;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RobotoText(
                      text: status.periodLabel,
                      fontSize: 11.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColor.kGrayTextColor,
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 8.h),
                    RobotoText(
                      text: status.completedLabel,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              AchievementPlanGapBadge(label: status.planGapLabel),
            ],
          ),
          SizedBox(height: 20.h),
          AchievementLinearProgressRow(
            label: 'planned_achievement_rate'.tr(),
            percentText: '٪${status.plannedPercent}',
            value: status.plannedPercent / 100,
            fillColor: Theme.of(context).textTheme.bodyMedium?.color ?? AppColor.kGrayTextColor,
          ),
          SizedBox(height: 14.h),
          AchievementLinearProgressRow(
            label: 'actual_achievement_rate'.tr(),
            percentText: '٪${status.actualPercent}',
            value: status.actualPercent / 100,
            fillColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
