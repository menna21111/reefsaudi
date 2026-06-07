import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.total,
    required this.underExecution,
    required this.delayed,
    required this.totalBudget,
  });

  final int total;
  final int underExecution;
  final int delayed;
  final double totalBudget;

  String _formatBudget(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}M';
    }
    return NumberFormat.compact().format(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: AppString.totalProjects.tr(),
                value: '$total',
                valueColor: colors.kPrimaryColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: AppString.underExecution.tr(),
                value: '$underExecution',
                borderColor: colors.kPrimaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: AppString.totalBudget.tr(),
                value: _formatBudget(totalBudget),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: AppString.delayed.tr(),
                value: '$delayed',
                valueColor: colors.kGoldColor,
                borderColor: colors.kGoldColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
