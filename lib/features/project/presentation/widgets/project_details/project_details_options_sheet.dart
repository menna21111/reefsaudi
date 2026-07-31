import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/permissions/app_permissions.dart';
import 'package:reefsaudia/core/permissions/permission_gate.dart';
import 'package:reefsaudia/core/services/service_locator.dart';
import 'package:reefsaudia/features/project/presentation/cubit/edit_project_cubit.dart';
import 'package:reefsaudia/features/project/presentation/cubit/project_statistics_cubit.dart';
import 'package:reefsaudia/features/project/presentation/screens/edit_project_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_blueprint_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_charter_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_statistics_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/risks_screen.dart';

import '../../../../../core/utils/app_font.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import 'project_details_menu_option.dart';

class ProjectDetailsOptionsSheet extends StatelessWidget {
  const ProjectDetailsOptionsSheet({
    super.key,
    required this.projectId,
    required this.completionPercent,
    required this.risksCount,
  });

  final String projectId;
  final double completionPercent;
  final int risksCount;

  static Future<void> show(
    BuildContext context, {
    required String projectId,
    required double completionPercent,
    required int risksCount,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true,
      builder: (_) => ProjectDetailsOptionsSheet(
        projectId: projectId,
        completionPercent: completionPercent,
        risksCount: risksCount,
      ),
    );
  }

  Future<void> _openEditProject(BuildContext context) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<EditProjectCubit>()..loadProject(projectId),
          child: EditProjectScreen(projectId: projectId),
        ),
      ),
    );

    if (updated == true && context.mounted) {
      context.read<ProjectDetailsCubit>().refreshSilently();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.kBorderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            RobotoText(
              text: AppString.projectOptions.tr(),
              color: colors.kPrimaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            ProjectDetailsMenuOption(
              title: AppString.completionPercentage.tr(),
              subtitle: '${completionPercent.toStringAsFixed(1)}%',
              icon: Icons.pie_chart_outline_rounded,
              screen: BlocProvider(
                create: (_) => sl<ProjectBlueprintCubit>()..load(projectId),
                child: ProjectBlueprintScreen(projectId: projectId),
              ),
            ),
            SizedBox(height: 12.h),
            ProjectDetailsMenuOption(
              title: AppString.riskManagement.tr(),
              subtitle: '$risksCount',
              icon: Icons.warning_amber_outlined,
              iconColor: colors.kRedColor,
              screen: BlocProvider(
                create: (_) => sl<ProjectRisksCubit>()..load(projectId),
                child: RisksScreen(projectId: projectId),
              ),
            ),
            SizedBox(height: 12.h),
            ProjectDetailsMenuOption(
              title: AppString.projectStatisticsMenu.tr(),
              icon: Icons.bar_chart_rounded,
              screen: ProjectStatisticsScreen(projectId: projectId),
            ),
            SizedBox(height: 12.h),
            // PermissionGate(
            //   permission: AppPermissions.projectEdit,
            //   child: 
              ProjectDetailsMenuOption(
                title: AppString.editProject.tr(),
                icon: Icons.edit_outlined,
                onTap: () => _openEditProject(context),
              ),
            // ),
           
            SizedBox(height: 12.h),
            ProjectDetailsMenuOption(
              title: AppString.projectCharter.tr(),
              icon: Icons.article_outlined,
              screen: BlocProvider(
                create: (_) => sl<ProjectCharterCubit>()..load(projectId),
                child: ProjectCharterScreen(projectId: projectId),
              ),
            ),
            SizedBox(height: 24.h),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.kBorderColor),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: RobotoText(
                text: AppString.cancel.tr(),
                color: colors.kRedColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
