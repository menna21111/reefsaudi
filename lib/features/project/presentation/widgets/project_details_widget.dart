import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';
import 'package:reefsaudia/core/utils/app_theme_context.dart';

class ProjectDetailsWidget extends StatelessWidget {
  final String status;
  final String statusColor;
  final String completionRate;
  final String responsibleParty;
  final String startDate;
  final String endDate;

  const ProjectDetailsWidget({
    super.key,
    required this.status,
    this.statusColor = 'primary',
    required this.completionRate,
    required this.responsibleParty,
    required this.startDate,
    required this.endDate,
  });

  Color _getStatusColor(BuildContext context) {
    final colors=context.appColors;
    switch (statusColor) {
      case 'primary':
        return colors.kPrimaryColor;
      case 'gold':
        return colors.kGoldColor;
      case 'red':
        return colors.kRedColor;
      default:
        return colors.kWhiteColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors=context.appColors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colors.kPrimaryColor,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'بيانات المشروع',
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(context, 'الحالة', status, _getStatusColor(context)),
          SizedBox(height: 12.h),
          _buildDetailRow(context, 'نسبة الانجاز', completionRate, colors.kFontColor),
          SizedBox(height: 12.h),
          _buildDetailRow(context, 'المسؤول', responsibleParty, colors.kFontColor),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateColumn(context, 'تاريخ البدء', startDate),
              _buildDateColumn(context, 'تاريخ الإنتهاء', endDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, Color valueColor) {
    final colors=context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: colors.kGrayColor, fontSize: 11.sp),
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

  Widget _buildDateColumn(BuildContext context, String label, String date) {
    final colors=context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: colors.kGrayColor, fontSize: 10.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          date,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
