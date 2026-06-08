import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_api_models.dart';
import 'custom_line_chart.dart';
import 'legend_item.dart';

class ProjectChartCard extends StatelessWidget {
  final double completionPercent;
  final List<ProjectAchievementPointDto> achievementPoints;

  const ProjectChartCard({
    super.key,
    required this.completionPercent,
    this.achievementPoints = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final actual = achievementPoints.map((e) => e.actual.toDouble()).toList();
    final planned = achievementPoints.map((e) => e.planned.toDouble()).toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: colors.kPrimaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                AppString.projectChartStatus.tr(),
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            AppString.projectCompletionPercent.tr(
              namedArgs: {'percent': completionPercent.toStringAsFixed(1)},
            ),
            style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: CustomLineChart(
              actualPoints: actual,
              plannedPoints: planned,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendItem(
                label: AppString.actual.tr(),
                color: colors.kPrimaryColor,
              ),
              SizedBox(width: 16.w),
              LegendItem(
                label: AppString.planned.tr(),
                color: colors.kGrayColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
