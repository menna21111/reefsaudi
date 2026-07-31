import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/project_request_detail_models.dart';
import '../../constants/request_type_config.dart';

class QualityRequestDetailSummaryCard extends StatelessWidget {
  const QualityRequestDetailSummaryCard({
    super.key,
    required this.detail,
  });

  final ProjectRequestDetail detail;

  String _formatDate(DateTime? date) {
    if (date == null) return AppString.notAvailable.tr();
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final config = RequestTypeRegistry.configFor(detail.requestTypeName);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            config.label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.kPrimaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontFamily: 'Almarai',
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            detail.projectName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              height: 1.45,
              fontFamily: 'Almarai',
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: AppString.serialNumber.tr(),
                  value: detail.serialNumber,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: AppString.requestDate.tr(),
                  value: _formatDate(detail.requestDate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 11.sp,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ],
    );
  }
}
