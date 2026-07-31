import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../cubit/project_statistics_cubit.dart';
import '../widgets/project_details/project_details_body.dart';
import '../widgets/project_details/project_details_options_sheet.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  void _openOptions(BuildContext context, ProjectDetailsState state) {
    final summary = state.executiveSummary.data;
    final risksCount = state.risks.items.length;
    final resolvedProjectId = state.projectData.data?.projectId.trim().isNotEmpty == true
        ? state.projectData.data!.projectId
        : projectId;

    ProjectDetailsOptionsSheet.show(
      context,
      projectId: resolvedProjectId,
      completionPercent: summary?.completionPercent ?? 0,
      risksCount: risksCount,
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
          BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(Icons.more_vert, color: colors.kFontColor),
                onPressed: () => _openOptions(context, state),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<ProjectDetailsCubit>().refresh(),
            color: colors.kPrimaryColor,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: const ProjectDetailsBody(),
          );
        },
      ),
    );
  }
}
