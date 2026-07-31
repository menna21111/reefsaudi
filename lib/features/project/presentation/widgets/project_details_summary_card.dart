import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_api_models.dart';
import 'project_detail_field.dart';

class ProjectDetailsSummaryCard extends StatelessWidget {
  const ProjectDetailsSummaryCard({
    super.key,
    required this.projectCode,
    required this.startDate,
    required this.endDate,
    required this.expectedDays,
  });

  final String projectCode;
  final String startDate;
  final String endDate;
  final int expectedDays;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          ProjectDetailField(
            label: AppString.projectCode.tr(),
            value: projectCode.isEmpty ? '-' : projectCode,
            valueColor: colors.kPrimaryColor,
          ),
          const ProjectDetailFieldGap(),
          ProjectDetailField(
            label: AppString.expectedProjectDays.tr(),
            value: expectedDays > 0 ? '$expectedDays' : '-',
          ),
          const ProjectDetailFieldGap(),
          ProjectDetailField(
            label: AppString.startDate.tr(),
            value: startDate.isEmpty ? '-' : startDate,
          ),
          const ProjectDetailFieldGap(),
          ProjectDetailField(
            label: AppString.endDate.tr(),
            value: endDate.isEmpty ? '-' : endDate,
          ),
        ],
      ),
    );
  }
}

String formatProjectDetailDate(String raw) {
  if (raw.isEmpty) return '';
  return formatApiDate(raw);
}

String formatProjectDetailDateTime(DateTime? date) {
  if (date == null) return '';
  return DateFormat('dd/MM/yyyy').format(date);
}
