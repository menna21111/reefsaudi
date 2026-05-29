import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

class ExecutiveSummaryWidget extends StatelessWidget {
  final String summary;
  final VoidCallback? onMorePressed;

  const ExecutiveSummaryWidget({
    Key? key,
    required this.summary,
    this.onMorePressed,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: AppColor.kPrimaryColor,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'ملخص تنفيذي',
                style: TextStyle(
                  color: AppColor.kWhiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            summary,
            style: TextStyle(
              color: AppColor.kGrayTextColor,
              fontSize: 10.sp,
              height: 1.6,
            ),
          ),
          SizedBox(height: 12.h),
          OutlinedButton(
            onPressed: onMorePressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColor.kPrimaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'المزيد',
                  style: TextStyle(
                    color: AppColor.kPrimaryColor,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward,
                  color: AppColor.kPrimaryColor,
                  size: 14.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
