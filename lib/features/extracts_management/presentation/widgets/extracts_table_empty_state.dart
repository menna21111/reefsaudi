import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsTableEmptyState extends StatelessWidget {
  const ExtractsTableEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 40.sp,
            color: AppColor.kGrayTextColor,
          ),
          SizedBox(height: 8.h),
          Text(
            'no_extracts_found'.tr(),
            style: TextStyle(
              color: AppColor.kGrayTextColor,
              fontSize: 13.sp,
              fontFamily: 'Almarai',
            ),
          ),
        ],
      ),
    );
  }
}
