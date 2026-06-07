import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color.dart';
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
    final actual = achievementPoints.map((e) => e.actual.toDouble()).toList();
    final planned = achievementPoints.map((e) => e.planned.toDouble()).toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 4.h),
          _buildSubHeader(completionPercent),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: CustomLineChart(
              actualPoints: actual,
              plannedPoints: planned,
            ),
          ),
          SizedBox(height: 16.h),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.bar_chart, color: AppColor.kWhiteColor, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          'حالة مخطط المشروع',
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSubHeader(double percent) {
    return Text(
      'النسبة المئوية لإنجاز المشروع: ${percent.toStringAsFixed(1)}%',
      style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        LegendItem(label: 'فعلي', color: AppColor.kPrimaryColor),
        SizedBox(width: 16),
        LegendItem(label: 'مخطط', color: AppColor.kGrayTextColor),
      ],
    );
  }
}
