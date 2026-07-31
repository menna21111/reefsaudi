import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_font.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/global_statistics_models.dart';
import '../statistics_style.dart';

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
          text: AppString.noData.tr(),
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
              titleSunbeamLayout: false,
              sections: List.generate(items.length, (index) {
                final item = items[index];
                final percent = (item.value / total) * 100;
                final showTitle = percent >= 8;
                return PieChartSectionData(
                  value: item.value.toDouble(),
                  color: palette[index % palette.length],
                  title: showTitle ? '${percent.toStringAsFixed(1)}%' : '',
                  showTitle: showTitle,
                  radius: 72.r,
                  titlePositionPercentageOffset: 0.62,
                  titleStyle: StatisticsStyle.label(
                    context,
                    color: StatisticsStyle.textOnAccent,
                    size: 10,
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
            final percent = (item.value / total) * 100;
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
                  '${_labelForKey(item.key)} (${percent.toStringAsFixed(1)}%)',
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
