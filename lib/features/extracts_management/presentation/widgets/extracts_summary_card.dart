import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsSummaryCard extends StatelessWidget {
  final String title;
  final String mainValue;
  final String approvedLabel;
  final String approvedValue;
  final String rejectedLabel;
  final String rejectedValue;
  final Color mainValueColor;

  const ExtractsSummaryCard({
    Key? key,
    required this.title,
    required this.mainValue,
    required this.approvedLabel,
    required this.approvedValue,
    required this.rejectedLabel,
    required this.rejectedValue,
    this.mainValueColor = AppColor.kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(color: AppColor.kWhiteColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mainValue,
                style: TextStyle(color: mainValueColor, fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(approvedLabel, style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp)),
                  Text(approvedValue, style: TextStyle(color: AppColor.kPrimaryColor, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(rejectedLabel, style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp)),
                  Text(rejectedValue, style: TextStyle(color: AppColor.kRedColor, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
