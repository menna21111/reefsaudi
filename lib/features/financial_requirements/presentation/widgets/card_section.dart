import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class CardSection extends StatelessWidget {
  final String title;
  final String mainValue;
  final String subtitle;
  final String? percentage;

  const CardSection({
    super.key,
    required this.title,
    required this.mainValue,
    required this.subtitle,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RobotoText(
          text: title,
          fontSize: 10.sp,
          color: AppColor.kGrayTextColor,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (percentage != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.kRedColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RobotoText(
                      text: percentage!,
                      fontSize: 9.sp,
                      color: AppColor.kRedColor,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: AppColor.kRedColor,
                      size: 11.sp,
                    ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
            RobotoText(
              text: mainValue,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.kPrimaryColor,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(height: 5.h),
        RobotoText(
          text: subtitle,
          fontSize: 9.sp,
          color: AppColor.kGrayTextColor,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
