import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/utils/app_color.dart';
import '../../data/models/project_api_models.dart';
import 'info_row.dart';

class ProjectInfoCard extends StatelessWidget {
  final String consultant;
  final String contractor;
  final String startDate;
  final String endDate;
  final double budget;

  const ProjectInfoCard({
    super.key,
    required this.consultant,
    required this.contractor,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Divider(color: AppColor.kInputBorderColor, height: 32.h),
          InfoRow(label: 'الاستشاري', value: consultant),
          SizedBox(height: 16.h),
          InfoRow(label: 'المقاول', value: contractor),
          SizedBox(height: 16.h),
          InfoRow(label: 'تاريخ البدء', value: formatApiDate(startDate)),
          SizedBox(height: 16.h),
          InfoRow(label: 'تاريخ الانتهاء', value: formatApiDate(endDate)),
          SizedBox(height: 16.h),
          InfoRow(
            label: 'الميزانية التعاقدية',
            value: budget.toStringAsFixed(0),
            valueColor: AppColor.kPrimaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.info_outline, color: AppColor.kPrimaryColor, size: 20.sp),
        SizedBox(width: 8.w),
        RobotoText(
          text: 'معلومات عن المشروع',
          color: AppColor.kWhiteColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
