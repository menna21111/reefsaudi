import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import 'extracts_summary_card.dart';

class ExtractsSummaryCards extends StatelessWidget {
  const ExtractsSummaryCards({
    super.key,
    required this.totalCount,
    required this.pageValueLabel,
    required this.completedCount,
    required this.inProcessCount,
  });

  final int totalCount;
  final String pageValueLabel;
  final int completedCount;
  final int inProcessCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: ExtractsSummaryCard(
            title: 'extracts_value'.tr(),
            mainValue: pageValueLabel,
            disbursedValue: '$completedCount',
            inProcessValue: '$inProcessCount',
            inProcessColor: colors.kRedColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ExtractsSummaryCard(
            title: 'extracts_count'.tr(),
            mainValue: '$totalCount',
            disbursedValue: '$completedCount',
            inProcessValue: '$inProcessCount',
            inProcessColor: colors.kGoldColor,
          ),
        ),
      ],
    );
  }
}
