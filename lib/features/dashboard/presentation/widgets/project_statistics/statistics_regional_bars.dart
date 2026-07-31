import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/global_statistics_models.dart';
import '../statistics_style.dart';

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

    final maxCount =
        filtered.map((a) => a.count).reduce((a, b) => a > b ? a : b);

    return Column(
      children: filtered.map((area) {
        final ratio = maxCount == 0 ? 0.0 : area.count / maxCount;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                area.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: StatisticsStyle.label(context, size: 11),
              ),
              SizedBox(width: 20.w),
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
