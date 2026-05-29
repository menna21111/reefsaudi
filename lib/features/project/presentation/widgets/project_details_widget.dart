import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

class ProjectDetailsWidget extends StatelessWidget {
  final String status;
  final String statusColor;
  final String completionRate;
  final String responsibleParty;
  final String startDate;
  final String endDate;

  const ProjectDetailsWidget({
    Key? key,
    required this.status,
    this.statusColor = 'primary',
    required this.completionRate,
    required this.responsibleParty,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (statusColor) {
      case 'primary':
        return AppColor.kPrimaryColor;
      case 'gold':
        return AppColor.kGoldColor;
      case 'red':
        return AppColor.kRedColor;
      default:
        return AppColor.kWhiteColor;
    }
  }

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
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColor.kPrimaryColor,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'بيانات المشروع',
                style: TextStyle(
                  color: AppColor.kWhiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDetailRow('الحالة', status, _getStatusColor()),
          SizedBox(height: 12.h),
          _buildDetailRow('نسبة الانجاز', completionRate, AppColor.kWhiteColor),
          SizedBox(height: 12.h),
          _buildDetailRow('المسؤول', responsibleParty, AppColor.kWhiteColor),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateColumn('تاريخ البدء', startDate),
              _buildDateColumn('تاريخ الإنتهاء', endDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 11.sp),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          date,
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
