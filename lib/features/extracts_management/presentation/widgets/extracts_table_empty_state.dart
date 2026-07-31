import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class ExtractsTableEmptyState extends StatelessWidget {
  const ExtractsTableEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40.sp, color: colors.kGrayColor),
          SizedBox(height: 8.h),
          Text(
            'no_extracts_found'.tr(),
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 13.sp,
              fontFamily: 'Almarai',
            ),
          ),
        ],
      ),
    );
  }
}
