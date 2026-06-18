import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/permissions/permission_gate.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../achievement_rates_management/presentation/screens/achievement_rates_management_screen.dart';
import '../../../project/presentation/screens/add_project_screen.dart';
import '../../../extracts_management/presentation/screens/extracts_management_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Drawer(
      backgroundColor: colors.kBgColor,
      child: Column(
        children: [
          SizedBox(height: 80.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                PermissionGate(
                  permission: AppPermissions.dashboardView,
                  child: _buildDrawerItem(
                    context,
                    icon: Icons.trending_up_rounded,
                    title: AppString.achievementManagement.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AchievementRatesManagementScreen(),
                        ),
                      );
                    },
                  ),
                ),
                PermissionGate(
                  permission: AppPermissions.financialView,
                  child: _buildDrawerItem(
                    context,
                    icon: Icons.receipt_long_rounded,
                    title: AppString.extractsManagement.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExtractsManagementScreen(),
                        ),
                      );
                    },
                  ),
                ),
                PermissionGate(
                  permission: AppPermissions.projectView,
                  child: _buildDrawerItem(
                    context,
                    icon: Icons.verified_user_rounded,
                    title: AppString.qualityManagementDrawer.tr(),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                PermissionGate(
                  permission: AppPermissions.taskManagementView,
                  child: _buildDrawerItem(
                    context,
                    icon: Icons.meeting_room_rounded,
                    title: AppString.meetingsManagement.tr(),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                PermissionGate(
                  permission: AppPermissions.dashboardView,
                  child: _buildDrawerItem(
                    context,
                    icon: Icons.insert_chart_rounded,
                    title: AppString.mainData.tr(),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                PermissionGate(
                  permission: AppPermissions.projectCreate,
                  child: _buildDrawerItem(
                    context,
                    icon: Icons.add_business_rounded,
                    title: AppString.addProject.tr(),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, AddProjectScreen.route());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;

    return ListTile(
      leading: Icon(icon, color: colors.kPrimaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: colors.kFontColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
