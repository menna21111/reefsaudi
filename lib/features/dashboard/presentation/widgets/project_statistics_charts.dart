import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/global_statistics_models.dart';
import 'statistics_style.dart';

class StatisticsSectionCard extends StatelessWidget {
  final String titleKey;
  final Widget child;
  final double? height;

  const StatisticsSectionCard({
    super.key,
    required this.titleKey,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RobotoText(
            text: titleKey,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colors.kFontColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          if (height != null) SizedBox(height: height, child: child) else child,
        ],
      ),
    );
  }
}

class StatisticsRegionalBars extends StatelessWidget {
  final List<AreaProjectDto> areas;

  const StatisticsRegionalBars({super.key, required this.areas});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sorted = List<AreaProjectDto>.from(areas)
      ..sort((a, b) => b.count.compareTo(a.count));
    final filtered = sorted.where((a) => a.regionCode != null).toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    final maxCount = filtered.map((a) => a.count).reduce((a, b) => a > b ? a : b);

    return Column(
      children: filtered.map((area) {
        final ratio = maxCount == 0 ? 0.0 : area.count / maxCount;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              SizedBox(
                width: 88.w,
                child: Text(
                  area.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: StatisticsStyle.label(context, size: 11),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: colors.kBorderColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: ratio.clamp(0.08, 1.0),
                      child: Container(
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: colors.kPrimaryColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${area.count}',
                          style: StatisticsStyle.label(
                            context,
                            color: StatisticsStyle.textOnAccent,
                            size: 10,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class StatisticsSectorBarChart extends StatelessWidget {
  final List<SectorProjectDto> sectors;

  const StatisticsSectorBarChart({super.key, required this.sectors});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (sectors.isEmpty) {
      return Center(
        child: RobotoText(
          text: AppString.noData,
          fontSize: 12,
          color: colors.kGrayColor,
        ),
      );
    }

    final barColors = StatisticsStyle.sectorBarColors(colors);
    final maxY = sectors.map((s) => s.count).reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxY * 1.2).ceilToDouble();

    return SizedBox(
      height: 220.h,
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
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.w,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: StatisticsStyle.label(context, size: 9),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52.h,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sectors.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(
                      sectors[index].title.trim(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: StatisticsStyle.label(context, size: 8),
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class StatisticsProjectStatusBar extends StatelessWidget {
  final List<StatisticsKeyValueDto> items;

  const StatisticsProjectStatusBar({super.key, required this.items});

  Color _colorForKey(String key, AppColorScheme colors) {
    switch (key) {
      case 'Good':
        return colors.kPrimaryColor;
      case 'Finished':
        return StatisticsStyle.statusFinished(colors);
      case 'Critical':
        return colors.kRedColor;
      default:
        return colors.kGoldColor;
    }
  }

  String _labelForKey(String key) {
    switch (key) {
      case 'Good':
        return AppString.statusGood.tr();
      case 'Finished':
        return AppString.finished.tr();
      case 'Critical':
        return AppString.statusCritical.tr();
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (items.isEmpty) return const SizedBox.shrink();

    final total = items.fold<int>(0, (sum, item) => sum + item.value);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            height: 36.h,
            child: Row(
              children: items.map((item) {
                return Expanded(
                  flex: item.value,
                  child: Container(
                    color: _colorForKey(item.key, colors),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.value}',
                      style: StatisticsStyle.label(
                        context,
                        color: StatisticsStyle.textOnAccent,
                        size: 12,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.center,
          children: items.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: _colorForKey(item.key, colors),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  _labelForKey(item.key),
                  style: StatisticsStyle.label(context, size: 11),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class StatisticsCountByTypePieChart extends StatelessWidget {
  final List<StatisticsKeyValueDto> items;

  const StatisticsCountByTypePieChart({super.key, required this.items});

  String _labelForKey(String key) {
    switch (key) {
      case 'Started':
        return AppString.projectTypeStarted.tr();
      case 'Awarded':
        return AppString.projectTypeAwarded.tr();
      case 'Signed':
        return AppString.projectTypeSigned.tr();
      case 'ReviewCommittee':
        return AppString.projectTypeReviewCommittee.tr();
      case 'Accreditation':
        return AppString.projectTypeAccreditation.tr();
      case 'Finished':
        return AppString.finished.tr();
      case 'Tender':
        return AppString.projectTypeTender.tr();
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (items.isEmpty) {
      return Center(
        child: RobotoText(
          text: AppString.noData,
          fontSize: 12,
          color: colors.kGrayColor,
        ),
      );
    }

    final palette = StatisticsStyle.piePalette(colors);
    final total = items.fold<int>(0, (sum, item) => sum + item.value);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: List.generate(items.length, (index) {
                final item = items[index];
                final percent = (item.value / total) * 100;
                return PieChartSectionData(
                  value: item.value.toDouble(),
                  color: palette[index % palette.length],
                  title: '${percent.toStringAsFixed(1)}%',
                  radius: 72.r,
                  titleStyle: StatisticsStyle.label(
                    context,
                    color: StatisticsStyle.textOnAccent,
                    size: 9,
                    weight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 12.h),
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
                    color: palette[index % palette.length],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  _labelForKey(item.key),
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
          text: AppString.noData,
          fontSize: 12,
          color: colors.kGrayColor,
        ),
      );
    }

    final qcColors = StatisticsStyle.qcPalette(colors);
    final total = items.fold<double>(0, (sum, item) => sum + item.statementsCount);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: [
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
                    text: AppString.totalLabel,
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
        SizedBox(height: 12.h),
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
