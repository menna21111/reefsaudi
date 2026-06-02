import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../domain/models/achievement_month_record.dart';

class AchievementCurveChart extends StatelessWidget {
  const AchievementCurveChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: const BarTouchData(enabled: false),
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            achievementChartValues.length,
            (index) {
              final reversedIndex = achievementChartValues.length - 1 - index;
              return _buildBarGroup(
                index,
                achievementChartValues[reversedIndex],
              );
            },
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColor.kPrimaryColor,
          width: 28.w,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: AppColor.kBorderLight,
          ),
        ),
      ],
    );
  }
}
