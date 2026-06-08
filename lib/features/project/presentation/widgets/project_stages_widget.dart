import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

import '../../../../core/utils/app_theme_context.dart';

class ProjectStagesWidget extends StatelessWidget {
  final List<StageData> stages;

  const ProjectStagesWidget({
    super.key,
    required this.stages,
  }) ;

  @override
  Widget build(BuildContext context) {
    final colors=context.appColors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stairs, color: colors.kPrimaryColor, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'مراحل المشروع',
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stages
                .asMap()
                .entries
                .map((entry) => _buildStageBar(
                      context,
                      entry.value.label,
                      entry.value.progress,
                      entry.key,
                    ))
                .toList(),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegend(context, 'مكتمل', colors.kPrimaryColor),
              _buildLegend(context, 'قيد التنفيذ', colors.kGoldColor),
              _buildLegend(context, 'مجدول', colors.kBorderColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageBar(BuildContext context, String label, double progress, int delay) {
    final colors=context.appColors;
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: colors.kBorderColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.bottomCenter,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: Duration(milliseconds: 1000 + (delay * 200)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                width: 60.w,
                height: 100.h * value,
                decoration: BoxDecoration(
                  color: colors.kPrimaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(color: colors.kGrayColor, fontSize: 9.sp),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, String label, Color color) {
    final colors=context.appColors;
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(color: colors.kGrayColor, fontSize: 9.sp),
        ),
      ],
    );
  }
}

class StageData {
  final String label;
  final double progress;

  StageData({required this.label, required this.progress});
}
