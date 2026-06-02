import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class AchievementPaginationPageNumber extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onTap;

  const AchievementPaginationPageNumber({
    super.key,
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.kPrimaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            color: isSelected
                ? AppColor.kPrimaryColor
                : AppColor.kGrayTextColor,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'Almarai',
          ),
        ),
      ),
    );
  }
}
