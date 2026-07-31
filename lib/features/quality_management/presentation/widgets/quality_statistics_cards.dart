import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_request_summary_models.dart';
import '../constants/request_type_config.dart';

class QualityStatisticsSummaryCard extends StatelessWidget {
  const QualityStatisticsSummaryCard({
    super.key,
    required this.total,
  });

  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: colors.kBorderColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.qualitySummary.tr(),
            style: TextStyle(
              color: colors.kPrimaryColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Almarai',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppString.totalProcessedRequests.tr(),
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            NumberFormat.decimalPattern().format(total),
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 34.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Almarai',
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class QualityStatisticsTypeCard extends StatelessWidget {
  const QualityStatisticsTypeCard({
    super.key,
    required this.item,
  });

  final ProjectRequestSummaryItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final config = RequestTypeRegistry.configFor(item.requestTypeName);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.kBorderColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: config.color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            ),
            child: Text(
              config.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.kWhiteColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              children: [
                _MetricRow(
                  colors: colors,
                  label: AppString.qcStatusAccepted.tr(),
                  value: item.accepted,
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF43A047),
                ),
                SizedBox(height: 10.h),
                _MetricRow(
                  colors: colors,
                  label: AppString.qcStatusInProgress.tr(),
                  value: item.inProgress,
                  icon: Icons.pending_actions_outlined,
                  iconColor: colors.kPrimaryColor,
                ),
                SizedBox(height: 10.h),
                _MetricRow(
                  colors: colors,
                  label: AppString.qcStatusReRequest.tr(),
                  value: item.reRequest,
                  icon: Icons.refresh_rounded,
                  iconColor: const Color(0xFFFB8C00),
                ),
                SizedBox(height: 10.h),
                _MetricRow(
                  colors: colors,
                  label: AppString.qcStatusRejected.tr(),
                  value: item.rejected,
                  icon: Icons.cancel_outlined,
                  iconColor: const Color(0xFFE53935),
                ),
                SizedBox(height: 10.h),
                _MetricRow(
                  colors: colors,
                  label: AppString.qcStatusHaveNote.tr(),
                  value: item.haveNote,
                  icon: Icons.task_alt_rounded,
                  iconColor: const Color(0xFF00897B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.colors,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final AppColorScheme colors;
  final String label;
  final int value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 13.sp,
              fontFamily: 'Almarai',
            ),
          ),
        ),
        Text(
          NumberFormat.decimalPattern().format(value),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ],
    );
  }
}
