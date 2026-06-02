import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class AchievementAddMonthButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AchievementAddMonthButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColor.kPrimaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RobotoText(
              text: 'add_month'.tr(),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.kBackgroundColor,
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.add_rounded,
              color: AppColor.kBackgroundColor,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
