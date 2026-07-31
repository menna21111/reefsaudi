import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/project_api_models.dart';
import '../../cubit/project_statistics_cubit.dart';
import '../project_details_shimmer.dart';
import '../project_details_summary_card.dart';
import '../project_image_card.dart';
import 'project_details_section_error.dart';

class ProjectDetailsSummarySection extends StatelessWidget {
  const ProjectDetailsSummarySection({super.key});

  Widget _buildImagesSlider(
    ProjectDetailsSectionState<ProjectImageDto> section,
  ) {
    if (section.isLoading ||
        section.status == ProjectDetailsSectionStatus.initial) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: const ProjectImagesShimmer(),
      );
    }

    if (section.hasError || section.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final imageUrls = section.items.map((image) => image.imageUrl).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: ProjectImageCard(imageUrls: imageUrls),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProjectDetailsCubit>().state;
    final projectData = state.projectData;
    final editProject = state.editProject;
    final imagesSection = _buildImagesSlider(state.projectImages);

    if (projectData.isLoading ||
        projectData.status == ProjectDetailsSectionStatus.initial) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          imagesSection,
          const ProjectSummaryCardShimmer(),
        ],
      );
    }

    if (projectData.hasError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          imagesSection,
          ProjectDetailsSectionError(
            message: projectData.errorMessage ?? '',
            onRetry: () => context.read<ProjectDetailsCubit>().loadProjectData(),
          ),
        ],
      );
    }

    final data = projectData.data!;
    final form = editProject.data;

    final projectCode = form?.projectCode.trim().isNotEmpty == true
        ? form!.projectCode
        : '';

    final startDate = form?.startDate != null
        ? formatProjectDetailDateTime(form!.startDate)
        : formatProjectDetailDate(data.startDate);

    final endDate = form?.endDate != null
        ? formatProjectDetailDateTime(form!.endDate)
        : formatProjectDetailDate(data.endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        imagesSection,
        ProjectDetailsSummaryCard(
          projectCode: projectCode,
          startDate: startDate,
          endDate: endDate,
          expectedDays: data.projectDuration,
        ),
      ],
    );
  }
}
