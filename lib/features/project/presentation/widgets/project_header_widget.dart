import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';
import 'package:reefsaudia/core/utils/app_theme_context.dart';

class ProjectHeaderWidget extends StatelessWidget {
  final String category;
  final String title;
  final String status;
  final int daysRunning;

  const ProjectHeaderWidget({
    super.key,
    required this.category,
    required this.title,
    required this.status,
    required this.daysRunning,
  });

  @override
  Widget build(BuildContext context) {
    final colors=context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: colors.kPrimaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: colors.kPrimaryColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            category,
            style: TextStyle(color: colors.kPrimaryColor, fontSize: 10.sp),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          title,
          style: TextStyle(
            color: colors.kFontColor,
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
              color: colors.kGrayColor,
              size: 12.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '$status - منذ $daysRunning يوم',
              style: TextStyle(color: colors.kGrayColor, fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }
}
