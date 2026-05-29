import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class MonthlyRecordCard extends StatelessWidget {
  final String month;
  final String plannedPercentage;
  final String actualPercentage;
  final double progressValue; // 0.0 to 1.0
  final Color progressColor;

  const MonthlyRecordCard({
    Key? key,
    required this.month,
    required this.plannedPercentage,
    required this.actualPercentage,
    required this.progressValue,
    required this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderLight, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.more_vert, color: AppColor.kGrayTextColor, size: 20.sp),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(month, style: TextStyle(color: AppColor.kWhiteColor, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _buildStatItem('الفعلي', actualPercentage, progressColor),
                      SizedBox(width: 16.w),
                      _buildStatItem('المخطط', plannedPercentage, AppColor.kGrayTextColor),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progressValue,
                      backgroundColor: AppColor.kBorderLight,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      strokeWidth: 4.w,
                    ),
                    Text(
                      '${(progressValue * 100).toInt()}%',
                      style: TextStyle(color: AppColor.kWhiteColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 12.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
