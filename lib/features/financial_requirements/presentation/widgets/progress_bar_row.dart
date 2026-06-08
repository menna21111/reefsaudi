import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class ProgressBarRow extends StatelessWidget {
  final String label;
  final String valueText;
  final double progress;
  final Color barColor;

  const ProgressBarRow({
    super.key,
    required this.label,
    required this.valueText,
    required this.progress,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RobotoText(
              text: label,
              fontSize: 11.sp,
              color: AppColor.kGrayTextColor,
            ),
            RobotoText(
              text: valueText,
              fontSize: 12.sp,
              color: AppColor.kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: 5.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: AppColor.kBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
