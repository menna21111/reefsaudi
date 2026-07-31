import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';

class ProjectDetailsSectionError extends StatelessWidget {
  const ProjectDetailsSectionError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Text(
            message.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.kRedColor, fontSize: 13.sp),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              AppString.retry.tr(),
              style: TextStyle(color: colors.kPrimaryColor, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}
