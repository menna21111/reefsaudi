import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_image.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/responsive.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key, this.trailing});

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final secondaryText =
        theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface;
    final isTablet = context.isTablet;
    final logoSize = isTablet ? 72.w : 44.w;

    return Container(
      width: double.infinity,
      // SafeArea already applied on login screen.
      padding: EdgeInsets.only(top: isTablet ? 24.h : 16.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (trailing != null)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: trailing!,
            ),
          Column(
            children: [
              SizedBox(height: isTablet ? 28.h : 20.h),
              Center(
                child: SvgPicture.asset(
                  AppImage.applogo,
                  width: logoSize,
                  height: logoSize,
                ),
              ),
              SizedBox(height: isTablet ? 20.h : 16.h),
              RobotoText(
                text: AppString.saudiReef.tr(),
                fontSize: isTablet ? 28.sp : 22.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
              SizedBox(height: 6.h),
              RobotoText(
                text: AppString.excellenceInManagingProjects.tr(),
                fontSize: isTablet ? 15.sp : 13.sp,
                fontWeight: FontWeight.w400,
                color: secondaryText,
              ),
              SizedBox(height: isTablet ? 40.h : 32.h),
            ],
          ),
        ],
      ),
    );
  }
}
