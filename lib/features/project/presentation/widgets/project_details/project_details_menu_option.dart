import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/funcation.dart';

import '../../../../../core/utils/app_theme_context.dart';

class ProjectDetailsMenuOption extends StatelessWidget {
  const ProjectDetailsMenuOption({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.screen,
    this.onTap,
    this.iconColor,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Widget? screen;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        if (onTap != null) {
          await onTap!();
        } else if (screen != null) {
          await AppFunctions.navigateTo(
            context,
            screen!,
            PageTransitionType.leftToRight,
          );
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.kBgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? colors.kPrimaryColor,
              size: 22.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: colors.kGrayColor,
                        fontSize: 11.sp,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: colors.kGrayColor,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
