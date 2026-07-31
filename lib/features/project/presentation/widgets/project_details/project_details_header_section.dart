import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/project_statistics_cubit.dart';
import '../project_details_shimmer.dart';
import '../project_header.dart';
import 'project_details_section_error.dart';

class ProjectDetailsHeaderSection extends StatelessWidget {
  const ProjectDetailsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final section = context.watch<ProjectDetailsCubit>().state.projectData;

    if (section.isLoading || section.status == ProjectDetailsSectionStatus.initial) {
      return const ProjectHeaderShimmer();
    }

    if (section.hasError) {
      return ProjectDetailsSectionError(
        message: section.errorMessage ?? '',
        onRetry: () => context.read<ProjectDetailsCubit>().loadProjectData(),
      );
    }

    final data = section.data!;
    return ProjectHeader(
      title: data.projectTitle,
      category: data.categoryLabel,
      status: data.stepTitle,
    );
  }
}
