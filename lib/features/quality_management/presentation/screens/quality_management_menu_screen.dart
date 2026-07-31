import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import 'quality_statistics_screen.dart';
import 'quality_requests_screen.dart';

class QualityManagementMenuScreen extends StatelessWidget {
  const QualityManagementMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.kFontColor),
        title: Text(
          AppString.qualityManagementDrawer.tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          _MenuCard(
            icon: Icons.bar_chart_rounded,
            iconColor: const Color(0xFF43A047),
            title: AppString.qualityStatistics.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QualityStatisticsScreen(),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          _MenuCard(
            icon: Icons.assignment_outlined,
            iconColor: colors.kPrimaryColor,
            title: AppString.myRequests.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QualityRequestsScreen.myRequests(),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          _MenuCard(
            icon: Icons.task_alt_rounded,
            iconColor: const Color(0xFFFB8C00),
            title: AppString.approvalTasks.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QualityRequestsScreen.approvalTasks(),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          _MenuCard(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF5C6BC0),
            title: AppString.requestsArchive.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QualityRequestsScreen.archive(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: colors.kInputColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colors.kBorderColor.withValues(alpha: 0.3),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 22.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: colors.kGrayColor,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
