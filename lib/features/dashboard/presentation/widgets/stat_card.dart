import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';
import 'card_border_painter.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final Color? borderColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      margin: EdgeInsets.only(right: borderColor != null ? 4.w : 0),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: borderColor != null
            ? Border(
                right: BorderSide(color: borderColor!, width: 4.w),
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RobotoText(
            text: title,

            color: AppColor.kGrayTextColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          RobotoText(
            text: value,

            color: valueColor ?? AppColor.kWhiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );

    return cardContent;
  }
}
