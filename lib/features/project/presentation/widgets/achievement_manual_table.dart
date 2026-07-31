import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_api_models.dart';

class AchievementManualTable extends StatelessWidget {
  const AchievementManualTable({
    super.key,
    required this.records,
    this.onEdit,
    this.onDelete,
  });

  final List<AchievementManualItemDto> records;
  final ValueChanged<AchievementManualItemDto>? onEdit;
  final ValueChanged<AchievementManualItemDto>? onDelete;

  static double _tableWidth(bool showActions) {
    return 150.w + 92.w + 92.w + (showActions ? 104.w : 0) + 32.w;
  }

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
    final showActions = onEdit != null || onDelete != null;
    final tableWidth = _tableWidth(showActions);

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: tableWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TableHeader(colors: colors, showActions: showActions),
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
                    showActions: showActions,
                    onEdit: onEdit == null ? null : () => onEdit!(record),
                    onDelete: onDelete == null ? null : () => onDelete!(record),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final AppColorScheme colors;
  final bool showActions;

  const _TableHeader({required this.colors, required this.showActions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.kDarkGrayColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              AppString.monthYear.tr(),
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 92.w,
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
          SizedBox(
            width: 92.w,
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
          if (showActions)
            SizedBox(
              width: 104.w,
              child: Text(
                AppString.actions.tr(),
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
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _TableRow({
    required this.month,
    required this.planned,
    required this.actual,
    required this.colors,
    required this.showDivider,
    required this.showActions,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              SizedBox(
                width: 150.w,
                child: Text(
                  month,
                  style: TextStyle(
                    color: colors.kWhiteColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 92.w,
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
              SizedBox(
                width: 92.w,
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
              if (showActions)
                SizedBox(
                  width: 104.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          onPressed: onEdit,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.edit_outlined,
                            color: colors.kPrimaryColor,
                            size: 18.sp,
                          ),
                        ),
                      if (onEdit != null && onDelete != null)
                        SizedBox(width: 8.w),
                      if (onDelete != null)
                        IconButton(
                          onPressed: onDelete,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: colors.kRedColor,
                            size: 18.sp,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: colors.kBorderColor.withValues(alpha: 0.25),
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
