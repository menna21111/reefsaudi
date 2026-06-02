import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsFilterButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ExtractsFilterButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColor.kSurfaceColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColor.kBorderColor.withOpacity(0.3),
          ),
        ),
        child: Icon(
          Icons.tune_rounded,
          color: AppColor.kPrimaryColor,
          size: 20.sp,
        ),
      ),
    );
  }
}
