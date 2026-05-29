import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';
import 'info_row.dart';

class ProjectInfoCard extends StatelessWidget {
  const ProjectInfoCard({super.key});

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
          InfoRow(label: 'تاريخ البدء', value: '25 يوليو 2022'),
          SizedBox(height: 16.h),
          InfoRow(label: 'تاريخ الانتهاء', value: '24 يونيو 2024'),
          SizedBox(height: 16.h),
          InfoRow(
            label: 'مدة المشروع (يوم)',
            value: '700 يوم',
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
        const Spacer(),
        RobotoText(
          text: 'PR-10',
          color: AppColor.kPrimaryColor,
          fontSize: 12.sp,
        ),
      ],
    );
  }
}
