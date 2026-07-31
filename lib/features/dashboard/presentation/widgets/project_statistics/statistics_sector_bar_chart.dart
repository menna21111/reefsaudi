import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart' as ui;
import '../../../../../core/utils/app_font.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/global_statistics_models.dart';
import '../statistics_style.dart';

class StatisticsSectorBarChart extends StatelessWidget {
  final List<SectorProjectDto> sectors;

  const StatisticsSectorBarChart({super.key, required this.sectors});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (sectors.isEmpty) {
      return Center(
        child: RobotoText(
          text: AppString.noData.tr(),
          fontSize: 12,
          color: colors.kGrayColor,
        ),
      );
    }

    final barColors = StatisticsStyle.sectorBarColors(colors);
    final maxY = sectors.map((s) => s.count).reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxY * 1.2).ceilToDouble();

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: SizedBox(
        height: 260.h,
        child: BarChart(
          BarChartData(
            maxY: chartMaxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: chartMaxY / 5,
              getDrawingHorizontalLine: (_) => FlLine(
                color: colors.kBorderColor.withValues(alpha: 0.25),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28.w,
                  getTitlesWidget: (value, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(
                      value.toInt().toString(),
                      style: StatisticsStyle.label(context, size: 9),
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 90.h,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= sectors.length) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      space: 12,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          sectors[index].title.trim(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StatisticsStyle.label(context, size: 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: List.generate(sectors.length, (index) {
              final sector = sectors[index];
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: sector.count.toDouble(),
                    width: 18.w,
                    color: barColors[index % barColors.length],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(4.r)),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
