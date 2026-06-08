import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48.sp,
            color: AppColor.kGrayTextColor,
          ),
          SizedBox(height: 12.h),
          RobotoText(
            text: AppString.noFinancialRequirements.tr(),
            fontSize: 14.sp,
            color: AppColor.kGrayTextColor,
          ),
        ],
      ),
    );
  }
}
