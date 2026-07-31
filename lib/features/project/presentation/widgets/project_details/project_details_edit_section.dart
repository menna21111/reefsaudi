import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/project_statistics_cubit.dart';
import '../project_details_readonly_sections.dart';
import '../project_details_shimmer.dart';
import 'project_details_section_error.dart';

class ProjectDetailsEditSection extends StatelessWidget {
  const ProjectDetailsEditSection({super.key});

  @override
  Widget build(BuildContext context) {
    final section = context.watch<ProjectDetailsCubit>().state.editProject;

    if (section.isLoading || section.status == ProjectDetailsSectionStatus.initial) {
      return const ProjectDetailsReadOnlyShimmer();
    }

    if (section.hasError) {
      return ProjectDetailsSectionError(
        message: section.errorMessage ?? '',
        onRetry: () => context.read<ProjectDetailsCubit>().loadEditProject(),
      );
    }

    return ProjectDetailsReadOnlySections(form: section.data!);
  }
}
