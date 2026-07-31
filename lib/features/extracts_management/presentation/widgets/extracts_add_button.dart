import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class ExtractsAddButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ExtractsAddButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: colors.kPrimaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.add_rounded, color: colors.kBgColor, size: 26.sp),
      ),
    );
  }
}
