import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_color_scheme.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/global_statistics_models.dart';
import '../statistics_style.dart';

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
