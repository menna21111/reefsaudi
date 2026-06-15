import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class ExtractsMapButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ExtractsMapButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
        ),
        child: Icon(
          Icons.map_outlined,
          color: colors.kPrimaryColor,
          size: 20.sp,
        ),
      ),
    );
  }
}
