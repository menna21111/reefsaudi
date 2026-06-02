import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsProfileAvatar extends StatelessWidget {
  const ExtractsProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.kBorderColor.withOpacity(0.5),
          width: 1.5,
        ),
        color: AppColor.kSurfaceColor,
      ),
      child: Icon(
        Icons.person_rounded,
        color: AppColor.kGrayTextColor,
        size: 22.sp,
      ),
    );
  }
}
