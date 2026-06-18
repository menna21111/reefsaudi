import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/permissions/permission_gate.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_theme_context.dart';

import '../../../risk_management/presentation/screens/risk_management_screen.dart';
import '../../../project/presentation/screens/add_project_screen.dart';
import '../screens/statices_homescrean.dart';
import '../screens/statistics_screen.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Icon(
              Icons.menu_rounded,
              color: colors.kPrimaryColor,
              size: 24.sp,
            ),
          ),
        ),
        Row(
          children: [
            PermissionGate(
              permission: AppPermissions.projectCreate,
              child: _ActionIcon(
                icon: Icons.add_rounded,
                colors: colors,
                onTap: () {
                  Navigator.push(context, AddProjectScreen.route());
                },
              ),
            ),
            SizedBox(width: 8.w),
            _ActionIcon(
              icon: Icons.warning_amber_outlined,
              colors: colors,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RiskManagementScreen(),
                  ),
                );
              },
            ),
            SizedBox(width: 8.w),
            _ActionIcon(
              icon: Icons.bar_chart_rounded,
              colors: colors,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StatisticsHomeScrean(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final AppColorScheme colors;
  final VoidCallback? onTap;

  const _ActionIcon({
    required this.icon,
    required this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          shape: BoxShape.circle,
          border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
        ),
        child: Icon(icon, color: colors.kWhiteColor, size: 20.sp),
      ),
    );
  }
}
