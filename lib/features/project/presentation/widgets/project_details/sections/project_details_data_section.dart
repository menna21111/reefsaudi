import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_string.dart';
import '../../../../../../core/utils/app_theme_context.dart';
import '../../../cubit/edit_project_state.dart';
import '../../project_detail_field.dart';
import '../project_details_field_helpers.dart';

class ProjectDetailsDataSection extends StatelessWidget {
  const ProjectDetailsDataSection({super.key, required this.form});

  final EditProjectFormData form;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        ProjectDetailField(
          label: AppString.projectTitleLabel.tr(),
          value: ProjectDetailsFieldHelpers.text(form.title),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.projectResponsible.tr(),
          value: ProjectDetailsFieldHelpers.selection(form.owner),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.generalConsultant.tr(),
          value: ProjectDetailsFieldHelpers.selection(form.consultant),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.contractor.tr(),
          value: ProjectDetailsFieldHelpers.selection(form.contractor),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.description.tr(),
          value: ProjectDetailsFieldHelpers.text(form.description),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.projectStartDate.tr(),
          value: ProjectDetailsFieldHelpers.date(form.startDate),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.expectedProjectEndDate.tr(),
          value: ProjectDetailsFieldHelpers.date(form.endDate),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.contractualBudget.tr(),
          value: ProjectDetailsFieldHelpers.budget(form.contractualBudget),
          valueColor: colors.kPrimaryColor,
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.estimatedBudget.tr(),
          value: ProjectDetailsFieldHelpers.budget(form.estimatedBudget),
          valueColor: colors.kPrimaryColor,
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.projectPhaseLabel.tr(),
          value: ProjectDetailsFieldHelpers.option(form.phaseKey),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.phaseJoinDate.tr(),
          value: ProjectDetailsFieldHelpers.date(form.phaseJoinDate),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.projectStatus.tr(),
          value: ProjectDetailsFieldHelpers.option(form.statusKey),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.sector.tr(),
          value: ProjectDetailsFieldHelpers.selection(form.sector),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.region.tr(),
          value: ProjectDetailsFieldHelpers.selection(form.region),
        ),
        const ProjectDetailFieldGap(),
        ProjectDetailField(
          label: AppString.projectTypeLabel.tr(),
          value: ProjectDetailsFieldHelpers.selection(form.projectType),
        ),
       
      ],
    );
  }
}
