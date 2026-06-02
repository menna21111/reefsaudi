import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import 'extracts_filter_button.dart';

class ExtractsPageTitleRow extends StatelessWidget {
  final VoidCallback? onFilterTap;

  const ExtractsPageTitleRow({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RobotoText(
          text: 'extracts_management'.tr(),
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.kWhiteColor,
          textAlign: TextAlign.right,
        ),
        ExtractsFilterButton(onTap: onFilterTap),
      ],
    );
  }
}
