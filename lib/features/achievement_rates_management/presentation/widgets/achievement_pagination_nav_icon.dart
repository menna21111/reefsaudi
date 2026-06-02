import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class AchievementPaginationNavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const AchievementPaginationNavIcon({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: onTap != null
            ? AppColor.kGrayTextColor
            : AppColor.kGrayTextColor.withOpacity(0.3),
        size: 22.sp,
      ),
    );
  }
}
