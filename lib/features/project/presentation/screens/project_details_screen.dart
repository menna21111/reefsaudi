import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/funcation.dart';
import 'package:reefsaudia/core/services/service_locator.dart';
import 'package:reefsaudia/features/extracts_management/presentation/screens/extracts_management_screen.dart';
import 'package:reefsaudia/features/project/presentation/cubit/project_statistics_cubit.dart';
import 'package:reefsaudia/features/project/presentation/screens/edit_project_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_blueprint_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_board_screen.dart';
import 'package:reefsaudia/features/project/presentation/screens/project_statistics_screen.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../widgets/project_chart_card.dart';
import '../widgets/project_header.dart';
import '../widgets/project_image_card.dart';
import '../widgets/project_info_card.dart';
import '../widgets/stats_row.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  void _showProjectActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true,
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
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: context.appColors.kBorderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                RobotoText(
                  text: AppString.projectOptions.tr(),
                  color: context.appColors.kPrimaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 20.h),
                _buildMenuOption(
                  context,
                  title: AppString.projectStatisticsMenu.tr(),
                  icon: Icons.bar_chart_rounded,
                  screen: ProjectStatisticsScreen(projectId: projectId),
                ),
                SizedBox(height: 12.h),
                _buildMenuOption(
                  context,
                  title: AppString.projectDocuments.tr(),
                  icon: Icons.folder_open_rounded,
                  screen: const EditProjectScreen(),
                ),
                SizedBox(height: 12.h),
                // _buildMenuOption(
                //   context,
                //   title: AppString.projectFinance.tr(),
                //   icon: Icons.account_balance_wallet_outlined,
                //   screen: const ExtractsManagementScreen(),
                // ),
                // SizedBox(height: 12.h),
                _buildMenuOption(
                  context,
                  title: AppString.projectBlueprintProgress.tr(),
                  icon: Icons.view_timeline_outlined,
                  screen: BlocProvider(
                    create: (_) => sl<ProjectBlueprintCubit>()..load(projectId),
                    child: ProjectBlueprintScreen(projectId: projectId),
                  ),
                ),
                // SizedBox(height: 12.h),
                // _buildMenuOption(
                //   context,
                //   title: AppString.projectTasksBoard.tr(),
                //   icon: Icons.assignment_turned_in_outlined,
                //   screen: const ProjectBoardScreen(),
                // ),
                SizedBox(height: 24.h),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.appColors.kBorderColor),
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: RobotoText(
                    text: AppString.cancel.tr(),
                    color: context.appColors.kRedColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
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
        Navigator.pop(context);
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
          color: context.appColors.kBgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.appColors.kBorderColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.appColors.kPrimaryColor, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: context.appColors.kFontColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Almarai',
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.appColors.kGrayColor,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: colors.kFontColor),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colors.kFontColor),
            onPressed: () => _showProjectActionsBottomSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
          if (state is ProjectDetailsLoading ||
              state is ProjectDetailsInitial) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }
          if (state is ProjectDetailsError) {
            return Center(
              child: Text(
                state.message.tr(),
                style: TextStyle(color: colors.kRedColor, fontSize: 16.sp),
              ),
            );
          }
          if (state is! ProjectDetailsLoaded) {
            return const SizedBox.shrink();
          }

          final bundle = state.bundle;
          final data = bundle.projectData;
          final summary = bundle.executiveSummary;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProjectHeader(
                  title: data.projectTitle,
                  category: data.categoryLabel,
                  status: data.stepTitle,
                ),
                SizedBox(height: 16.h),  ProjectInfoCard(
                  consultant: data.consultantTitle,
                  contractor: data.contractorTitle,
                  startDate: data.startDate,
                  endDate: data.endDate,
                  budget: data.contractualBudget,
                ),   SizedBox(height: 24.h),   StatsRow(
                  projectId: projectId,
                  completionPercent: summary.completionPercent,
                  executionPercent: summary.actual,
                  risksCount: bundle.risks.length,
                ), SizedBox(height: 16.h),
                ProjectChartCard(
                  completionPercent: summary.completionPercent,
                  achievementPoints: bundle.achievement,
                ),
               
             
                // SizedBox(height: 24.h),
                // const ProjectImageCard(),
             
              
              ],
            ),
          );
        },
      ),
    );
  }
}
