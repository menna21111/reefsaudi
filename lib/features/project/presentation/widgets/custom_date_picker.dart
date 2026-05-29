import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final String dateText;
  final VoidCallback onTap;

  const CustomDatePicker({
    Key? key,
    required this.label,
    required this.dateText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColor.kGrayTextColor,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColor.kInputBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColor.kInputBorderColor, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.date_range, color: AppColor.kPrimaryColor, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  dateText,
                  style: TextStyle(color: AppColor.kWhiteColor, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
