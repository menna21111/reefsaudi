import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_string.dart';
import '../../../cubit/edit_project_state.dart';
import '../../project_detail_field.dart';
import '../project_details_field_helpers.dart';

class ProjectDetailsManagementSection extends StatelessWidget {
  const ProjectDetailsManagementSection({super.key, required this.form});

  final EditProjectFormData form;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field(AppString.pmConsultant.tr(), form.projectManagementConsultant),
        const ProjectDetailFieldGap(),
        _field(AppString.architecturalOfficer.tr(), form.architecturalOfficer),
        const ProjectDetailFieldGap(),
        _field(AppString.mechanicalOfficer.tr(), form.mechanicalOfficer),
        const ProjectDetailFieldGap(),
        _field(AppString.electricalOfficer.tr(), form.electricalOfficer),
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
