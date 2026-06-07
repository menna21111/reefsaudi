import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RobotoText(
          text: AppString.financialStatements.tr(),
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.kWhiteColor,
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColor.kSurfaceColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColor.kGrayTextColor,
            size: 20.sp,
          ),
        ),
      ],
    );
  }
}
