import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_api_models.dart';

class AchievementManualTable extends StatelessWidget {
  final List<AchievementManualItemDto> records;

  const AchievementManualTable({super.key, required this.records});

  String _formatMonth(BuildContext context, String monthYear) {
    final date = DateTime.tryParse(monthYear);
    if (date == null) return monthYear;
    return DateFormat.yMMMM(context.locale.toString()).format(date);
  }

  String _formatPercent(double value) {
    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    }
    return '${value.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TableHeader(colors: colors),
          if (records.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Center(
                child: Text(
                  AppString.noData.tr(),
                  style: TextStyle(
                    color: colors.kGrayColor,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            )
          else
            ...records.asMap().entries.map((entry) {
              final record = entry.value;
              final isLast = entry.key == records.length - 1;
              return _TableRow(
                month: _formatMonth(context, record.monthYear),
                planned: _formatPercent(record.planned),
                actual: _formatPercent(record.actual),
                colors: colors,
                showDivider: !isLast,
              );
            }),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final AppColorScheme colors;

  const _TableHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.kDarkGrayColor.withOpacity(0.35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              AppString.monthYear.tr(),
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              AppString.planned.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              AppString.actual.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String month;
  final String planned;
  final String actual;
  final AppColorScheme colors;
  final bool showDivider;

  const _TableRow({
    required this.month,
    required this.planned,
    required this.actual,
    required this.colors,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  month,
                  style: TextStyle(
                    color: colors.kWhiteColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  planned,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.kGoldColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  actual,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.kPrimaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: colors.kBorderColor.withOpacity(0.25),
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
