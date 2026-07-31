import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_request_history_models.dart';

class QualityRequestHistoryTimeline extends StatelessWidget {
  const QualityRequestHistoryTimeline({
    super.key,
    required this.items,
  });

  final List<ProjectRequestHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(message: AppString.noData.tr());
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          _TimelineStep(
            item: items[i],
            isLast: i == items.length - 1,
          ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.item,
    required this.isLast,
  });

  final ProjectRequestHistoryItem item;
  final bool isLast;

  String _formatDate(DateTime? date) {
    if (date == null || date.year <= 1900) return '-';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  ({Color color, String label}) _statusStyle(
    AppColorScheme colors,
    RequestHistoryStepStatus status,
  ) {
    return switch (status) {
      RequestHistoryStepStatus.completed => (
          color: const Color(0xFF43A047),
          label: AppString.statusCompleted.tr(),
        ),
      RequestHistoryStepStatus.inProgress => (
          color: const Color(0xFFFB8C00),
          label: AppString.qcStatusInProgress.tr(),
        ),
      RequestHistoryStepStatus.waiting => (
          color: colors.kGrayColor,
          label: AppString.statusWaiting.tr(),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final statusStyle = _statusStyle(colors, item.status);
    final lineColor = item.status == RequestHistoryStepStatus.completed
        ? const Color(0xFF43A047)
        : colors.kBorderColor.withValues(alpha: 0.35);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28.w,
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: statusStyle.color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colors.kBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.kBorderColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: colors.kFontColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusStyle.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            statusStyle.label,
                            style: TextStyle(
                              color: statusStyle.color,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: LinearProgressIndicator(
                        value: item.progress.clamp(0, 100) / 100,
                        minHeight: 6.h,
                        backgroundColor:
                            colors.kBorderColor.withValues(alpha: 0.25),
                        color: statusStyle.color,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 16.sp,
                          color: colors.kGrayColor,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            item.assignedTo.trim().isEmpty
                                ? AppString.notAvailable.tr()
                                : item.assignedTo.trim(),
                            style: TextStyle(
                              color: colors.kFontColor,
                              fontSize: 12.sp,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _formatDate(item.date),
                      style: TextStyle(
                        color: colors.kGrayColor,
                        fontSize: 11.sp,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Icon(
          Icons.timeline_outlined,
          color: colors.kGrayColor.withValues(alpha: 0.6),
          size: 48.sp,
        ),
        SizedBox(height: 8.h),
        Text(
          message,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 13.sp,
            fontFamily: 'Almarai',
          ),
        ),
      ],
    );
  }
}
