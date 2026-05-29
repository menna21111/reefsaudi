import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

class ProjectHeaderWidget extends StatelessWidget {
  final String category;
  final String title;
  final String status;
  final int daysRunning;

  const ProjectHeaderWidget({
    Key? key,
    required this.category,
    required this.title,
    required this.status,
    required this.daysRunning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColor.kPrimaryColor.withOpacity(0.3)),
          ),
          child: Text(
            category,
            style: TextStyle(color: AppColor.kPrimaryColor, fontSize: 10.sp),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          title,
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColor.kGrayTextColor,
              size: 12.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '$status - منذ $daysRunning يوم',
              style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }
}
