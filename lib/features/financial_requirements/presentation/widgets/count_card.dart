import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';

class CountCard extends StatelessWidget {
  const CountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RobotoText(
            text: AppString.listsCount.tr(),
            fontSize: 11.sp,
            color: AppColor.kGrayTextColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 6.h),
          RobotoText(
            text: '281',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kWhiteColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 6.h),
          Divider(color: AppColor.kBorderColor.withOpacity(0.3), height: 1),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RobotoText(
                text: AppString.countWithInProgress.tr(namedArgs: {'count': '42'}),
                fontSize: 9.sp,
                color: AppColor.kGoldColor,
              ),
              RobotoText(
                text: AppString.countWithPaid.tr(namedArgs: {'count': '239'}),
                fontSize: 9.sp,
                color: AppColor.kPrimaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
