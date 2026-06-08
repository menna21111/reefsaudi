import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

import '../../../../core/utils/app_theme_context.dart';

class CashFlowWidget extends StatelessWidget {
  final List<double> line1Data;
  final List<double> line2Data;
  final List<double> line3Data;

  const CashFlowWidget({
    super.key,
    required this.line1Data,
    required this.line2Data,
    required this.line3Data,
  });

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
              Icon(Icons.timeline, color: colors.kPrimaryColor, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'التدفق الإجمالي'.tr(),
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 120.h,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: colors.kBorderColor.withValues(alpha: 0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // First line (Turquoise)
                      LineChartBarData(
                        spots: line1Data
                            .asMap()
                            .entries
                            .map((entry) => FlSpot(
                                entry.key.toDouble(), entry.value * value))
                            .toList(),
                        isCurved: true,
                        color: colors.kPrimaryColor,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                      // Second line (Yellow)
                      LineChartBarData(
                        spots: line2Data
                            .asMap()
                            .entries
                            .map((entry) => FlSpot(
                                entry.key.toDouble(), entry.value * value))
                            .toList(),
                        isCurved: true,
                        color: AppColor.kGoldColor,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                      // Third line (Green)
                      LineChartBarData(
                        spots: line3Data
                            .asMap()
                            .entries
                            .map((entry) => FlSpot(
                                entry.key.toDouble(), entry.value * value))
                            .toList(),
                        isCurved: true,
                        color: colors.kPrimaryColor,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
