import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reefsaudia/core/utils/app_color.dart';
import 'package:reefsaudia/core/utils/app_theme_context.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors=context.appColors;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'مؤشر نسبة الإنجاز',
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 160.w,
            height: 160.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 50.r,
                        startDegreeOffset: -90,
                        sections: [
                          PieChartSectionData(
                            color: colors.kPrimaryColor,
                            value: value * 100,
                            title: '',
                            radius: 25.r,
                          ),
                          PieChartSectionData(
                            color: colors.kBorderColor.withValues(alpha: 0.3),
                            value: (1 - value) * 100,
                            title: '',
                            radius: 25.r,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: (progress * 100).toInt()),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$value%',
                          style: TextStyle(
                            color: colors.kPrimaryColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'مكتمل',
                          style: TextStyle(
                            color: colors.kGrayColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            height: 8.h,
            decoration: BoxDecoration(
              color: colors.kBorderColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Container(
                      width: (MediaQuery.of(context).size.width - 72.w) * value,
                      decoration: BoxDecoration(
                        color: colors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%',
                style: TextStyle(
                  color: colors.kGrayColor,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                '100%',
                style: TextStyle(
                  color: colors.kGrayColor,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
