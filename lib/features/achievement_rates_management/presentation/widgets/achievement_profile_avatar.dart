import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class AchievementProfileAvatar extends StatelessWidget {
  const AchievementProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.kBorderColor.withOpacity(0.5),
        ),
        color: AppColor.kSurfaceColor,
      ),
      child: Icon(
        Icons.person_rounded,
        color: AppColor.kGrayTextColor,
        size: 20.sp,
      ),
    );
  }
}
