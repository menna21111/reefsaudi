import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/models/achievement_month_record.dart';
import 'achievement_circular_progress.dart';
import 'achievement_month_stat.dart';

class AchievementMonthlyRecordCard extends StatelessWidget {
  final AchievementMonthRecord record;

  const AchievementMonthlyRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          AchievementCircularProgress(
            value: record.progressValue,
            color: record.progressColor,
            percent: record.actualPercent,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RobotoText(
                    text: record.monthLabel,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color ?? AppColor.kWhiteColor,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AchievementMonthStat(
                        label: 'planned'.tr(),
                        value: '${record.plannedPercent}%',
                        valueColor: Theme.of(context).textTheme.bodyMedium?.color ?? AppColor.kGrayTextColor,
                      ),
                      SizedBox(width: 16.w),
                      AchievementMonthStat(
                        label: 'actual'.tr(),
                        value: '${record.actualPercent}%',
                        valueColor: record.progressColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.more_vert_rounded,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}
