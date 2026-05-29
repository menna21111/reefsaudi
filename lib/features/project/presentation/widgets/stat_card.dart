import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData? icon;
  final bool showBottomLine;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.icon,
    this.showBottomLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          RobotoText(
            text: title,
            color: AppColor.kGrayTextColor,
            fontSize: 12.sp,
          ),
          SizedBox(height: 8.h),
          _buildValueRow(),
          if (showBottomLine) _buildBottomLine(),
        ],
      ),
    );
  }

  Widget _buildValueRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 4.w),
        ],
        RobotoText(
          text: value,
          color: color,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _buildBottomLine() {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(height: 2.h, width: 40.w, color: color),
      ],
    );
  }
}
