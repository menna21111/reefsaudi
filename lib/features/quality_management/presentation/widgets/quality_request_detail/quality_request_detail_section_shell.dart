import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';

class QualityRequestDetailSectionShell extends StatelessWidget {
  const QualityRequestDetailSectionShell({
    super.key,
    required this.title,
    required this.icon,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.collapsible = true,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final bool collapsible;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: collapsible ? onToggle : null,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              child: Row(
                children: [
                  Icon(icon, color: colors.kPrimaryColor, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: colors.kFontColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  ?trailing,
                  if (collapsible)
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: colors.kGrayColor,
                    ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: child,
            ),
        ],
      ),
    );
  }
}
