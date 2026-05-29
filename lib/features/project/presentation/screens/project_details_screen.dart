import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/funcation.dart';
import 'package:reefsaudia/features/project/presentation/screens/edit_project_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_statistics_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_blueprint_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_board_screen.dart';
import 'package:reefsaudia/features/financial_requirements/presentation/screens/financial_requirements_screen.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../widgets/project_chart_card.dart';
import '../widgets/project_header.dart';
import '../widgets/project_image_card.dart';
import '../widgets/project_info_card.dart';
import '../widgets/stats_row.dart';

class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key});

  void _showProjectActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.kSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true, // مهم للسماح بالتمرير
      builder: (_) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bottom sheet handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.kBorderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                RobotoText(
                  text: 'خيارات المشروع',
                  color: AppColor.kPrimaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 20.h),

                // Options List
                _buildMenuOption(
                  context,
                  title: 'إحصائيات المشروع',
                  icon: Icons.bar_chart_rounded,
                  screen: const ProjectStatisticsScreen(),
                ),
                SizedBox(height: 12.h),
                _buildMenuOption(
                  context,
                  title: 'أوراق المشروع',
                  icon: Icons.folder_open_rounded,
                  screen: const EditProjectScreen(),
                ),
                SizedBox(height: 12.h),
                _buildMenuOption(
                  context,
                  title: 'المالية',
                  icon: Icons.account_balance_wallet_outlined,
                  screen: const FinancialRequirementsScreen(),
                ),
                SizedBox(height: 12.h),
                _buildMenuOption(
                  context,
                  title: 'المخطط ونسبة الإنجاز',
                  icon: Icons.view_timeline_outlined,
                  screen: const ProjectBlueprintScreen(),
                ),
                SizedBox(height: 12.h),
                _buildMenuOption(
                  context,
                  title: 'لوحة المهام',
                  icon: Icons.assignment_turned_in_outlined,
                  screen: const ProjectBoardScreen(),
                ),
                SizedBox(height: 24.h),

                // Cancel button
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.kInputBorderColor),
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: RobotoText(
                    text: 'إلغاء',
                    color: AppColor.kRedColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h), // مسافة إضافية في النهاية
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close bottom sheet
        AppFunctions.navigateTo(
          context,
          screen,
          PageTransitionType.leftToRight,
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColor.kBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColor.kBorderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.kPrimaryColor, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColor.kWhiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Almarai',
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColor.kGrayTextColor,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColor.kWhiteColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColor.kWhiteColor),
            onPressed: () => _showProjectActionsBottomSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProjectHeader(),
            SizedBox(height: 16),
            ProjectChartCard(),
            SizedBox(height: 16),
            StatsRow(),
            SizedBox(height: 24),
            ProjectImageCard(),
            SizedBox(height: 24),
            ProjectInfoCard(),
          ],
        ),
      ),
    );
  }
}
