import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';

class ClaimsCard extends StatelessWidget {
  const ClaimsCard({super.key});

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
            text: AppString.financialClaims.tr(),
            fontSize: 11.sp,
            color: AppColor.kGrayTextColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 6.h),
          RobotoText(
            text: '0',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kRedColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RobotoText(
                text: '100%',
                fontSize: 11.sp,
                color: AppColor.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_upward_rounded,
                color: AppColor.kPrimaryColor,
                size: 13.sp,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          RobotoText(
            text: AppString.previousValueWithAmount.tr(namedArgs: {'amount': '323.1M'}),
            fontSize: 9.sp,
            color: AppColor.kGrayTextColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
