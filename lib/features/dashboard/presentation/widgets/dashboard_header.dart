import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Icon(
              Icons.menu_rounded,
              color: AppColor.kPrimaryColor,
              size: 24.sp,
            ),
          ),
        ),
        Row(
          children: [
            _buildActionIcon(Icons.warning_amber_outlined),
            SizedBox(width: 8.w),
            _buildActionIcon(Icons.folder_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Icon(icon, color: AppColor.kWhiteColor, size: 20.sp),
    );
  }
}
