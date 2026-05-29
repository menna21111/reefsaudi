import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';

class ActionsRow extends StatelessWidget {
  final bool isTableView;
  final VoidCallback onViewToggle;

  const ActionsRow({
    super.key,
    required this.isTableView,
    required this.onViewToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFilterButton(),
        SizedBox(width: 8.w),
        _buildViewToggleButton(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, color: AppColor.kGrayTextColor, size: 16.sp),
          SizedBox(width: 8.w),
          RobotoText(
            text: AppString.filter.tr(),

            color: AppColor.kGrayTextColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton() {
    return GestureDetector(
      onTap: onViewToggle,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isTableView
              ? AppColor.kPrimaryColor.withOpacity(0.2)
              : AppColor.kSurfaceColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isTableView
                ? AppColor.kPrimaryColor
                : AppColor.kBorderColor.withOpacity(0.3),
          ),
        ),
        child: Icon(
          isTableView ? Icons.list_rounded : Icons.grid_view_rounded,
          color: isTableView ? AppColor.kPrimaryColor : AppColor.kGrayTextColor,
          size: 20.sp,
        ),
      ),
    );
  }
}
