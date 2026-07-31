import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';

class PortfolioOverviewTitle extends StatelessWidget {
  const PortfolioOverviewTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text(
      AppString.statistics.tr(),
      style: TextStyle(
        color: colors.kWhiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
