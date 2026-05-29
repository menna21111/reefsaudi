import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/models/financial_requirement.dart';

class FinancialRequirementCard extends StatelessWidget {
  final FinancialRequirement item;

  const FinancialRequirementCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(item.status);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          right: BorderSide(color: AppColor.kSecondaryColor, width: 4.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Top row: status pill + date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RobotoText(
                text: item.date,
                fontSize: 11.sp,
                color: AppColor.kGrayTextColor,
              ),
              _buildStatusPill(statusData),
            ],
          ),
          SizedBox(height: 10.h),
          // Project name
          RobotoText(
            text: item.projectName,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kWhiteColor,
            textAlign: TextAlign.right,
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          // Amount + contractor row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RobotoText(
                    text: 'الجهة المنفذة',
                    fontSize: 10.sp,
                    color: AppColor.kGrayTextColor,
                  ),
                  SizedBox(height: 2.h),
                  RobotoText(
                    text: item.contractor,
                    fontSize: 12.sp,
                    color: AppColor.kWhiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RobotoText(
                    text: 'القيمة',
                    fontSize: 10.sp,
                    color: AppColor.kGrayTextColor,
                  ),
                  SizedBox(height: 2.h),
                  RobotoText(
                    text: '${item.amount} SAR',
                    fontSize: 14.sp,
                    color: AppColor.kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RobotoText(
                text: '${(item.progressPercent * 100).toInt()}%',
                fontSize: 11.sp,
                color: AppColor.kWhiteColor,
                fontWeight: FontWeight.bold,
              ),
              RobotoText(
                text: 'نسبة الإنجاز',
                fontSize: 10.sp,
                color: AppColor.kGrayTextColor,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: item.progressPercent,
              minHeight: 5.h,
              backgroundColor: AppColor.kBackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                statusData['color'] as Color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(Map<String, dynamic> statusData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (statusData['color'] as Color).withOpacity(0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: (statusData['color'] as Color).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: statusData['color'] as Color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          RobotoText(
            text: statusData['label'] as String,
            fontSize: 10.sp,
            color: statusData['color'] as Color,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusData(FinancialRequirementStatus status) {
    switch (status) {
      case FinancialRequirementStatus.funded:
        return {'color': AppColor.kPrimaryColor, 'label': 'ممول'};
      case FinancialRequirementStatus.unfunded:
        return {'color': AppColor.kGoldColor, 'label': 'غير ممول'};
      case FinancialRequirementStatus.completed:
        return {'color': Colors.cyan, 'label': 'مكتمل'};
      default:
        return {'color': AppColor.kGrayTextColor, 'label': 'الكل'};
    }
  }
}
