import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_string.dart';
import '../../../cubit/edit_project_state.dart';
import '../../project_detail_field.dart';
import '../project_details_field_helpers.dart';

class ProjectDetailsSupervisionSection extends StatelessWidget {
  const ProjectDetailsSupervisionSection({super.key, required this.form});

  final EditProjectFormData form;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field(AppString.supervisionConsultant.tr(), form.supervisionConsultant),
        const ProjectDetailFieldGap(),
        _field(AppString.supervisionEngineer.tr(), form.supervisionEngineer),
        const ProjectDetailFieldGap(),
        _field(AppString.civilEngineer.tr(), form.civilEngineer),
        const ProjectDetailFieldGap(),
        _field(AppString.architecturalEngineer.tr(), form.architecturalEngineer),
        const ProjectDetailFieldGap(),
        _field(AppString.electricalEngineer.tr(), form.electricalEngineer),
        const ProjectDetailFieldGap(),
        _field(AppString.mechanicalEngineer.tr(), form.mechanicalEngineer),
        const ProjectDetailFieldGap(),
        _field(AppString.surveyEngineer.tr(), form.surveyEngineer),
        const ProjectDetailFieldGap(),
        _field(AppString.agriculturalEngineer.tr(), form.agriculturalEngineer),
        const ProjectDetailFieldGap(),
        _field(AppString.generalEngineer.tr(), form.generalEngineer),
      ],
    );
  }

  Widget _field(String label, SelectionValue value) {
    return ProjectDetailField(
      label: label,
      value: ProjectDetailsFieldHelpers.selection(value),
    );
  }
}
