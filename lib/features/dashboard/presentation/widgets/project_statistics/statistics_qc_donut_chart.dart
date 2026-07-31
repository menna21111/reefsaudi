import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_font.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/global_statistics_models.dart';
import '../statistics_style.dart';

class StatisticsQcDonutChart extends StatelessWidget {
  final List<GlobalQcCategoryDto> items;

  const StatisticsQcDonutChart({super.key, required this.items});

  String _formatTotal(double total) {
    if (total >= 1000) {
      return '${(total / 1000).toStringAsFixed(0)}K';
    }
    return total.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (items.isEmpty) {
      return Center(
        child: RobotoText(
          text: AppString.noData.tr(),
          fontSize: 12,
          color: colors.kGrayColor,
        ),
      );
    }

    final qcColors = StatisticsStyle.qcPalette(colors);
    final total =
        items.fold<double>(0, (sum, item) => sum + item.statementsCount);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 20.h,),
        SizedBox(
          height: 200.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 52.r,
                  sections: List.generate(items.length, (index) {
                    final item = items[index];
                    return PieChartSectionData(
                      value: item.statementsCount,
                      color: qcColors[index % qcColors.length],
                      radius: 64.r,
                      showTitle: false,
                    );
                  }),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RobotoText(
                    text: AppString.totalLabel.tr(),
                    fontSize: 10,
                    color: colors.kGrayColor,
                  ),
                  Text(
                    _formatTotal(total),
                    style: StatisticsStyle.value(
                      context,
                      color: colors.kFontColor,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.center,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: qcColors[index % qcColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  StatisticsStyle.localizeQcCategory(item.category),
                  style: StatisticsStyle.label(context, size: 10),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
