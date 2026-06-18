import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/task_item.dart';

class TasksTaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;

  const TasksTaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  String _display(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? AppString.notAvailable.tr() : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colors.kBorderColor.withOpacity(0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.kBlackColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (task.category.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: task.indicatorColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      task.category,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.kWhiteColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                color: colors.kFontColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                                fontFamily: 'Almarai',
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: task.badgeColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              task.statusLabel,
                              style: TextStyle(
                                color: task.badgeTextColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Almarai',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Divider(
                        height: 1,
                        color: colors.kBorderColor.withOpacity(0.35),
                      ),
                      SizedBox(height: 14.h),
                      _InfoRow(
                        colors: colors,
                        leftLabel: AppString.requestDate.tr(),
                        leftValue: _display(task.requestDate),
                        rightLabel: AppString.contractor.tr(),
                        rightValue: _display(task.contractor),
                      ),
                      SizedBox(height: 12.h),
                      _InfoRow(
                        colors: colors,
                        leftLabel: AppString.serialNumber.tr(),
                        leftValue: _display(task.serialNumber),
                        rightLabel: AppString.revisionNumber.tr(),
                        rightValue: _display(task.revisionNumber),
                      ),
                      SizedBox(height: 12.h),
                      _InfoRow(
                        colors: colors,
                        leftLabel: AppString.currentTasks.tr(),
                        leftValue: _display(task.currentTask),
                        rightLabel: AppString.assignedTo.tr(),
                        rightValue: _display(task.owner),
                      ),
                      SizedBox(height: 12.h),
                      _InfoRow(
                        colors: colors,
                        leftLabel: AppString.specialization.tr(),
                        leftValue: _display(task.specialization),
                        rightLabel: AppString.deliveryStatus.tr(),
                        rightValue: _display(task.deliveryStatus),
                      ),
                      if (task.description.trim().isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        _InfoCell(
                          colors: colors,
                          label: AppString.description.tr(),
                          value: _display(task.description),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.colors,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final AppColorScheme colors;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InfoCell(
            colors: colors,
            label: leftLabel,
            value: leftValue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _InfoCell(
            colors: colors,
            label: rightLabel,
            value: rightValue,
          ),
        ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.colors,
    required this.label,
    required this.value,
  });

  final AppColorScheme colors;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            height: 1.35,
            fontFamily: 'Almarai',
          ),
        ),
      ],
    );
  }
}
