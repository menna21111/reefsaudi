import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';

class ExecutionRateChartWidget extends StatelessWidget {
  final List<double> actualPoints;
  final List<double> plannedPoints;

  const ExecutionRateChartWidget({
    super.key,
    List<double>? actualPoints,
    List<double>? plannedPoints,
    List<double>? dataPoints,
  })  : actualPoints = actualPoints ?? dataPoints ?? const [],
        plannedPoints = plannedPoints ?? const [];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasPlanned = plannedPoints.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart_rounded,
                color: colors.kPrimaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppString.achievementCurve.tr(),
                  style: TextStyle(
                    color: colors.kWhiteColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 180.h,
            child: actualPoints.isEmpty
                ? Center(
                    child: Text(
                      AppString.noData.tr(),
                      style: TextStyle(
                        color: colors.kGrayColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                : TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 25,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: colors.kBorderColor.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (_) =>
                                  colors.kDarkGrayColor.withOpacity(0.95),
                              getTooltipItems: (spots) => spots
                                  .map(
                                    (spot) => LineTooltipItem(
                                      '${spot.y.toStringAsFixed(1)}%',
                                      TextStyle(
                                        color: colors.kWhiteColor,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          lineBarsData: [
                            if (hasPlanned)
                              LineChartBarData(
                                spots: plannedPoints
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => FlSpot(
                                        entry.key.toDouble(),
                                        entry.value * value,
                                      ),
                                    )
                                    .toList(),
                                isCurved: true,
                                color: colors.kGoldColor,
                                barWidth: 2.5,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                dashArray: [6, 4],
                              ),
                            LineChartBarData(
                              spots: actualPoints
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => FlSpot(
                                      entry.key.toDouble(),
                                      entry.value * value,
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              color: colors.kPrimaryColor,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: colors.kPrimaryColor.withOpacity(0.15),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              if (hasPlanned) ...[
                _LegendDot(color: colors.kGoldColor),
                SizedBox(width: 6.w),
                Text(
                  AppString.planned.tr(),
                  style: TextStyle(
                    color: colors.kGrayColor,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(width: 16.w),
              ],
              _LegendDot(color: colors.kPrimaryColor),
              SizedBox(width: 6.w),
              Text(
                AppString.actual.tr(),
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

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
