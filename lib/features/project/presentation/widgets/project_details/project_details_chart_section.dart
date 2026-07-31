import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';
import '../../cubit/project_statistics_cubit.dart';
import '../project_chart_card.dart';
import '../project_details_shimmer.dart';
import 'project_details_section_error.dart';

class ProjectDetailsChartSection extends StatelessWidget {
  const ProjectDetailsChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProjectDetailsCubit>().state;
    final summary = state.executiveSummary;
    final achievement = state.achievement;
    final colors = context.appColors;

    final isLoading = summary.isLoading ||
        achievement.isLoading ||
        summary.status == ProjectDetailsSectionStatus.initial ||
        achievement.status == ProjectDetailsSectionStatus.initial;

    if (isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
        ),
        child: const ProjectChartCardShimmer(),
      );
    }

    if (summary.hasError || achievement.hasError) {
      return ProjectDetailsSectionError(
        message: summary.errorMessage ?? achievement.errorMessage ?? '',
        onRetry: () {
          final cubit = context.read<ProjectDetailsCubit>();
          if (summary.hasError) cubit.loadExecutiveSummary();
          if (achievement.hasError) cubit.loadAchievement();
        },
      );
    }

    return ProjectChartCard(
      completionPercent: summary.data!.completionPercent,
      achievementPoints: achievement.items,
    );
  }
}
