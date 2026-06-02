import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
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
    this.inProcessColor = AppColor.kGoldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RobotoText(
            text: title,
            fontSize: 11.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColor.kGrayTextColor,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          RobotoText(
            text: mainValue,
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExtractsSummarySubStat(
                label: 'disbursed'.tr(),
                value: disbursedValue,
                valueColor: Theme.of(context).colorScheme.primary,
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
