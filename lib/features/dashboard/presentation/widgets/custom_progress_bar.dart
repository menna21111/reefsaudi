import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class CustomProgressBar extends StatelessWidget {
  final String label;
  final String percentageText;
  final double percentage; // 0.0 to 1.0
  final Color color;
  final Color backgroundColor;

  const CustomProgressBar({
    Key? key,
    required this.label,
    required this.percentageText,
    required this.percentage,
    required this.color,
    this.backgroundColor = AppColor.kBorderLight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp)),
            Text(percentageText, style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }
}
