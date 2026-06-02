import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import 'extracts_summary_card.dart';

class ExtractsSummaryCards extends StatelessWidget {
  const ExtractsSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ExtractsSummaryCard(
            title: 'extracts_value'.tr(),
            mainValue: '34.4M',
            disbursedValue: '285.6M',
            inProcessValue: '46.8M',
            inProcessColor: AppColor.kRedColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ExtractsSummaryCard(
            title: 'extracts_count'.tr(),
            mainValue: '292',
            disbursedValue: '255',
            inProcessValue: '37',
            inProcessColor: AppColor.kGoldColor,
          ),
        ),
      ],
    );
  }
}
