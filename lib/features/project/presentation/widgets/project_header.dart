import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/utils/app_theme_context.dart';

class ProjectHeader extends StatelessWidget {
  final String title;
  final String category;
  final String status;

  const ProjectHeader({
    super.key,
    required this.title,
    required this.category,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.precision_manufacturing,
              color: colors.kPrimaryColor,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: RobotoText(
                textAlign: TextAlign.start,
                text: title,
                color: colors.kFontColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (category.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.kGlowColor),
              color: AppColor.kGlowColor.withOpacity(.4),
              borderRadius: BorderRadiusDirectional.circular(4.r)
            ),
            child: Text(
              category,
              style: TextStyle(color: colors.kFontColor, fontSize: 11.sp),
            ),
          ),
        ],
        if (status.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Container(
             padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.kGlowColor),
              color: AppColor.kGlowColor.withOpacity(.4),
              borderRadius: BorderRadiusDirectional.circular(4.r)
            ),
            child: Text(
              status,
              style: TextStyle(color: colors.kFontColor, fontSize: 11.sp),
            ),
          ),
        ],
      ],
    );
  }
}
