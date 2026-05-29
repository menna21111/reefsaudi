import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';

class ProjectHeader extends StatelessWidget {
  const ProjectHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.precision_manufacturing,
          color: AppColor.kPrimaryColor,
          size: 20.sp,
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: RobotoText(
            text: 'توريد معدات ومواد زراعية\nلمشروع الوحدة البحثية',
            color: AppColor.kWhiteColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
