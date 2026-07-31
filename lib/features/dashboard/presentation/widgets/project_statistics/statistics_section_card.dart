import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_font.dart';
import '../../../../../core/utils/app_theme_context.dart';

class StatisticsSectionCard extends StatelessWidget {
  final String titleKey;
  final Widget child;
  final double? height;

  const StatisticsSectionCard({
    super.key,
    required this.titleKey,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RobotoText(
            text: titleKey.tr(),
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colors.kFontColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          if (height != null) SizedBox(height: height, child: child) else child,
        ],
      ),
    );
  }
}
