import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../cubit/portfolio_overview_cubit.dart';

class PortfolioOverviewErrorView extends StatelessWidget {
  const PortfolioOverviewErrorView({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.kRedColor, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            FilledButton(
              onPressed: () => context.read<PortfolioOverviewCubit>().load(),
              child: Text(AppString.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
