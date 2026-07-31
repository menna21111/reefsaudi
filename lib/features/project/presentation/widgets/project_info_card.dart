import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import 'package:reefsaudia/core/utils/app_theme_context.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../data/models/project_api_models.dart';
import 'info_row.dart';

class ProjectInfoCard extends StatelessWidget {
  final String consultant;
  final String contractor;
  final String startDate;
  final String endDate;
  final String projectcode;
  final double budget;

  const ProjectInfoCard({
    super.key,
    required this.projectcode,
    required this.consultant,
    required this.contractor,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Divider(color: AppColor.kInputBorderColor, height: 32.h),
          InfoRow(label: AppString.consultant.tr(), value: consultant),
          SizedBox(height: 16.h),
          InfoRow(label: AppString.contractor.tr(), value: contractor),
          SizedBox(height: 16.h),
          InfoRow(
            label: AppString.startDate.tr(),
            value: formatApiDate(startDate),
          ),
          SizedBox(height: 16.h),
          InfoRow(label: AppString.endDate.tr(), value: formatApiDate(endDate)),
          SizedBox(height: 16.h),
          InfoRow(
            label: AppString.contractualBudget.tr(),
            value: budget.toStringAsFixed(0),
            valueColor: AppColor.kPrimaryColor,
          ),
           SizedBox(height: 16.h),
          InfoRow(
            label: AppString.projectCode.tr(),
            value: projectcode,
            valueColor: AppColor.kPrimaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: AppColor.kPrimaryColor, size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: RobotoText(
            text: AppString.projectInfoTitle.tr(),
            color: colors.kFontColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
