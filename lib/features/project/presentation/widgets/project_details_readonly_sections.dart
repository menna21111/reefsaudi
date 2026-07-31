import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../cubit/edit_project_state.dart';
import 'edit_project/edit_project_section_card.dart';
import 'project_details/sections/project_details_data_section.dart';
import 'project_details/sections/project_details_management_section.dart';
import 'project_details/sections/project_details_supervision_section.dart';

class ProjectDetailsReadOnlySections extends StatelessWidget {
  const ProjectDetailsReadOnlySections({super.key, required this.form});

  final EditProjectFormData form;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EditProjectSectionCard(
          icon: Icons.data_usage_outlined,
          title: AppString.projectDataSection.tr(),
          children: [ProjectDetailsDataSection(form: form)],
        ),
        SizedBox(height: 16.h),
        EditProjectSectionCard(
          icon: Icons.engineering_outlined,
          title: AppString.supervisionManagementSection.tr(),
          children: [ProjectDetailsSupervisionSection(form: form)],
        ),
        SizedBox(height: 16.h),
        EditProjectSectionCard(
          icon: Icons.business_center_outlined,
          title: AppString.projectManagementSection.tr(),
          children: [ProjectDetailsManagementSection(form: form)],
        ),
      ],
    );
  }
}
