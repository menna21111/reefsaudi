import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_image.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../chat/chat.dart';
import '../../../extracts_management/presentation/screens/extracts_management_screen.dart';
import '../../../form_building/domain/models/form_building_module.dart';
import '../../../form_building/presentation/form_building_screen_factory.dart';
import '../../../quality_management/presentation/screens/quality_requests_screen.dart';
import '../../../quality_management/presentation/screens/quality_statistics_screen.dart';
import '../../../risk_management/presentation/screens/risk_management_screen.dart';
import '../../../meetings/presentation/screens/my_meetings_screen.dart';
import '../cubit/dashboard_cubit.dart';
import '../screens/dashboard_screen.dart';
import '../screens/statices_homescrean.dart';
import '../screens/statistics_screen.dart';
import 'drawer/drawer_menu_widgets.dart';
import 'drawer/drawer_pattern_background.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Drawer(
      backgroundColor: colors.kBgColor,
      child: DrawerPatternBackground(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(bottom: 24.h),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                child: Text(
                  AppString.saudiReef.tr(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: colors.kPrimaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              DrawerExpandableSection(
                icon: Icons.bar_chart_rounded,
                titleKey: AppString.dashboard,
                initiallyExpanded: true,
                children: [
                  DrawerMenuEntry(
                    titleKey: AppString.projectStatisticsDashboard,
                    permission: AppPermissions.dashboardView,
                    visibleToAdmin: true,
                    onTap: (context) =>
                        drawerPush(context, const StatisticsHomeScrean()),
                  ),
                  DrawerMenuEntry(
                    titleKey: AppString.financialStatements,
                    permission: AppPermissions.financialStatementView,
                    visibleToAdmin: true,
                    onTap: (context) =>
                        drawerPush(context, const StatisticsScreen()),
                  ),
                ],
              ),
              DrawerExpandableSection(
                icon: Icons.business_center_outlined,
                titleKey: AppString.projectManagementSection,
                children: [
                  DrawerMenuEntry(
                    titleKey: AppString.projects,
                    permission: AppPermissions.projectView,
                    visibleToAdmin: true,
                    onTap: (context) => drawerPush(
                      context,
                      BlocProvider.value(
                        value: sl<DashboardCubit>(),
                        child: const DashboardScreen(),
                      ),
                    ),
                  ),
                  DrawerMenuEntry(
                    titleKey: AppString.extracts,
                    permission: AppPermissions.financialStatementView,
                    visibleToAdmin: true,
                    onTap: (context) =>
                        drawerPush(context, const ExtractsManagementScreen()),
                  ),
                  DrawerMenuEntry(
                    titleKey: AppString.projectRiskManagement,
                    permission: AppPermissions.projectView,
                    visibleToAdmin: true,
                    onTap: (context) =>
                        drawerPush(context, const RiskManagementScreen()),
                  ),
                ],
              ),
              DrawerExpandableSection(
                icon: Icons.history_rounded,
                titleKey: AppString.qualityManagement,
                children: [
                  DrawerMenuEntry(
                    titleKey: AppString.qualityStatistics,
                    anyOfPermissions: const [
                      AppPermissions.requestTaskView,
                      AppPermissions.projectRequests,
                      AppPermissions.dynamicFormView,
                    ],
                    onTap: (context) =>
                        drawerPush(context, const QualityStatisticsScreen()),
                  ),
                  DrawerMenuEntry(
                    titleKey: AppString.myRequests,
                    anyOfPermissions: const [
                      AppPermissions.projectRequests,
                      AppPermissions.requestTaskView,
                    ],
                    onTap: (context) =>
                        drawerPush(context, QualityRequestsScreen.myRequests()),
                  ),
                  DrawerMenuEntry(
                    titleKey: AppString.approvalTasks,
                    permission: AppPermissions.requestTaskView,
                    onTap: (context) => drawerPush(
                      context,
                      QualityRequestsScreen.approvalTasks(),
                    ),
                  ),
                  DrawerMenuEntry(
                    titleKey: AppString.requestsArchive,
                    anyOfPermissions: const [
                      AppPermissions.projectRequests,
                      AppPermissions.requestTaskView,
                    ],
                    onTap: (context) =>
                        drawerPush(context, QualityRequestsScreen.archive()),
                  ),
                ],
              ),
              DrawerExpandableSection(
                icon: Icons.history_rounded,
                titleKey: AppString.meetingsManagement,
                children: [
                  DrawerMenuEntry(
                    titleKey: AppString.myMeetings,
                    onTap: (context) =>
                        drawerPush(context, const MyMeetingsScreen()),
                  ),
                  DrawerMenuEntry(
                    titleKey: AppString.meetingDashboard,
                    onTap: drawerShowComingSoon,
                  ),
                ],
              ),
              DrawerExpandableSection(
                iconPath: AppImage.messages,
                titleKey: AppString.fahimAi,
                children: [
                  DrawerMenuEntry(
                    titleKey: AppString.fahimAi,
                    onTap: (context) {
                      Navigator.pop(context);
                      openChatScreen(context);
                    },
                  ),
                ],
              ),
              DrawerExpandableSection(
                icon: Icons.article_outlined,
                titleKey: AppString.mainData,
                children: [
                  for (final module in FormBuildingModule.mainDataModules)
                    DrawerMenuEntry(
                      titleKey: module.titleKey,
                      permission: module.viewPermission,
                      visibleToAdmin: true,
                      onTap: (context) => drawerPush(
                        context,
                        FormBuildingScreenFactory.build(module),
                      ),
                    ),
                ],
              ),
              DrawerExpandableSection(
                icon: Icons.design_services_outlined,
                titleKey: AppString.formsBuilder,
                children: [
                  for (final module in FormBuildingModule.formsBuilderModules)
                    DrawerMenuEntry(
                      titleKey: module.titleKey,
                      permission: module.viewPermission,
                      visibleToAdmin: true,
                      onTap: (context) => drawerPush(
                        context,
                        FormBuildingScreenFactory.build(module),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
