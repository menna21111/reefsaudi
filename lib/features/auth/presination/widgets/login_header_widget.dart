import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_image.dart';
import '../../../../core/utils/app_string.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key, this.trailing});

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final secondaryText =
        theme.textTheme.bodyMedium?.color ?? colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.h),
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
              SizedBox(height: 20.h),
              Center(
                child: SvgPicture.asset(
                  AppImage.applogo,
                  width: 44.w,
                  height: 44.w,
                ),
              ),
              SizedBox(height: 16.h),
              RobotoText(
                text: AppString.saudiReef.tr(),
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
              SizedBox(height: 6.h),
              RobotoText(
                text: AppString.excellenceInManagingProjects.tr(),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: secondaryText,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ],
      ),
    );
  }
}
