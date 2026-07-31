import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';

class PortfolioSectionHeader extends StatelessWidget {
  const PortfolioSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
  });

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: colors.kPrimaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: colors.kWhiteColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: TextStyle(
              color: colors.kPrimaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
