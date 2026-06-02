import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsBrandRow extends StatelessWidget {
  const ExtractsBrandRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'saudi_reef_brand'.tr(),
          style: TextStyle(
            color: AppColor.kPrimaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'LamaSans',
          ),
        ),
        SizedBox(width: 8.w),
        Icon(
          Icons.grid_view_rounded,
          color: AppColor.kPrimaryColor,
          size: 20.sp,
        ),
      ],
    );
  }
}
