import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../cubit/project_statistics_cubit.dart';
import '../widgets/achievement_manual_table.dart';
import '../widgets/execution_rate_chart_widget.dart';

class ProjectBlueprintScreen extends StatelessWidget {
  final String projectId;

  const ProjectBlueprintScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<ProjectBlueprintCubit, ProjectBlueprintState>(
      builder: (context, state) {
        final loaded = state is ProjectBlueprintLoaded ? state : null;
        final latestActual = loaded?.latestRecord?.actual ?? 0;
        final totalCount = loaded?.totalCount ?? 0;

        return Scaffold(
          backgroundColor: colors.kBgColor,
          appBar: AppBar(
            backgroundColor: colors.kInputColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colors.kWhiteColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppString.blueprintAndAchievement.tr(),
              style: TextStyle(
                color: colors.kWhiteColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: _buildBody(context, state, loaded, latestActual, totalCount),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProjectBlueprintState state,
    ProjectBlueprintLoaded? loaded,
    double latestActual,
    int totalCount,
  ) {
    final colors = context.appColors;

    if (state is ProjectBlueprintLoading) {
      return Center(
        child: CircularProgressIndicator(color: colors.kPrimaryColor),
      );
    }

    if (state is ProjectBlueprintError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            state.message.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.kGrayColor, fontSize: 14.sp),
          ),
        ),
      );
    }

    if (loaded == null) {
      return const SizedBox.shrink();
    }

    final chronological = loaded.records.reversed.toList();
    final actualPoints = chronological.map((e) => e.actual).toList();
    final plannedPoints = chronological.map((e) => e.planned).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: AppString.completionPercentage.tr(),
                  value: _formatPercent(latestActual),
                  icon: Icons.trending_up_rounded,
                  iconColor: colors.kPrimaryColor,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _SummaryCard(
                  title: AppString.totalRecords.tr(),
                  value: '$totalCount',
                  icon: Icons.calendar_month_rounded,
                  iconColor: colors.kGoldColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          ExecutionRateChartWidget(
            actualPoints: actualPoints,
            plannedPoints: plannedPoints,
          ),
          SizedBox(height: 24.h),
          Text(
            AppString.monthlyAchievementLog.tr(),
            style: TextStyle(
              color: colors.kWhiteColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          AchievementManualTable(records: loaded.records),
          if (loaded.totalPages > 1) ...[
            SizedBox(height: 20.h),
            _PaginationBar(state: loaded),
          ],
        ],
      ),
    );
  }

  String _formatPercent(double value) {
    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    }
    return '${value.toStringAsFixed(2)}%';
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.kGrayColor,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  value,
                  style: TextStyle(
                    color: colors.kWhiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
        ],
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final ProjectBlueprintLoaded state;

  const _PaginationBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cubit = context.read<ProjectBlueprintCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          enabled: state.currentPage > 1,
          onTap: () => cubit.changePage(state.currentPage - 1),
        ),
        SizedBox(width: 12.w),
        Text(
          '${AppString.page.tr()} ${state.currentPage} / ${state.totalPages}',
          style: TextStyle(
            color: colors.kWhiteColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 12.w),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          enabled: state.currentPage < state.totalPages,
          onTap: () => cubit.changePage(state.currentPage + 1),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: enabled
          ? colors.kPrimaryColor.withOpacity(0.15)
          : colors.kDarkGrayColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Icon(
            icon,
            color: enabled ? colors.kPrimaryColor : colors.kGrayColor,
            size: 22.sp,
          ),
        ),
      ),
    );
  }
}
