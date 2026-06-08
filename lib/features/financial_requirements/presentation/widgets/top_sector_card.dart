import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import 'progress_bar_row.dart';

class TopSectorCard extends StatelessWidget {
  const TopSectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RobotoText(
                text: AppString.topSectorFinancialClaims.tr(),
                fontSize: 12.sp,
                color: AppColor.kGrayTextColor,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColor.kPrimaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.eco_rounded,
                  color: AppColor.kPrimaryColor,
                  size: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          RobotoText(
            text: AppString.sectorFruits.tr(),
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kPrimaryColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 14.h),
          ProgressBarRow(
            label: AppString.paid.tr(),
            valueText: AppString.amountWithCurrency.tr(namedArgs: {
              'amount': '47.1M',
              'currency': AppString.currencyRiyal.tr(),
            }),
            progress: 0.82,
            barColor: AppColor.kPrimaryColor,
          ),
          SizedBox(height: 10.h),
          ProgressBarRow(
            label: AppString.inProgress.tr(),
            valueText: AppString.amountWithCurrency.tr(namedArgs: {
              'amount': '9.0M',
              'currency': AppString.currencyRiyal.tr(),
            }),
            progress: 0.18,
            barColor: AppColor.kGoldColor,
          ),
        ],
      ),
    );
  }
}
