import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

enum DashboardHeaderLeading { drawer, back }

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    this.leading = DashboardHeaderLeading.drawer,
    this.titleKey,
    this.trailing,
  });

  final DashboardHeaderLeading leading;
  final String? titleKey;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        if (leading == DashboardHeaderLeading.drawer)
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(
                Icons.menu_rounded,
                color: colors.kPrimaryColor,
                size: 24.sp,
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colors.kPrimaryColor,
              size: 22.sp,
            ),
          ),
        if (titleKey != null) ...[
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              titleKey!.tr(),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: colors.kWhiteColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Almarai',
              ),
            ),
          ),
        ] else
          const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
