import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_theme_context.dart';
import 'extracts_summary_sub_stat.dart';

class ExtractsSummaryCard extends StatelessWidget {
  final String title;
  final String mainValue;
  final String disbursedValue;
  final String inProcessValue;
  final Color inProcessColor;

  const ExtractsSummaryCard({
    super.key,
    required this.title,
    required this.mainValue,
    required this.disbursedValue,
    required this.inProcessValue,
    required this.inProcessColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RobotoText(
            text: title,
            fontSize: 11.sp,
            color: colors.kGrayColor,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          RobotoText(
            text: mainValue,
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: colors.kPrimaryColor,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExtractsSummarySubStat(
                label: 'disbursed'.tr(),
                value: disbursedValue,
                valueColor: colors.kPrimaryColor,
              ),
              ExtractsSummarySubStat(
                label: 'in_process'.tr(),
                value: inProcessValue,
                valueColor: inProcessColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
