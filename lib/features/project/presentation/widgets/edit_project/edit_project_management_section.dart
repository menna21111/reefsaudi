import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/network/account_user_type.dart';
import '../../../../../core/utils/app_string.dart';
import '../../cubit/edit_project_state.dart';
import 'edit_project_account_dropdown.dart';
import 'edit_project_section_card.dart';

class EditProjectManagementSection extends StatelessWidget {
  const EditProjectManagementSection({
    super.key,
    required this.form,
    this.requiredFields = false,
    this.showValidationErrors = false,
  });

  final EditProjectFormData form;
  final bool requiredFields;
  final bool showValidationErrors;

  @override
  Widget build(BuildContext context) {
    return EditProjectSectionCard(
      icon: Icons.business_center_outlined,
      title: AppString.projectManagementSection.tr(),
      children: [
        EditProjectAccountDropdown(
          title: AppString.pmConsultant.tr(),
          value: form.projectManagementConsultant,
          required: requiredFields,
          showValidationError: showValidationErrors,
          userType: AccountUserType.consultant,
          map: (v) => form.copyWith(projectManagementConsultant: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.architecturalOfficer.tr(),
          value: form.architecturalOfficer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(architecturalOfficer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.mechanicalOfficer.tr(),
          value: form.mechanicalOfficer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(mechanicalOfficer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.electricalOfficer.tr(),
          value: form.electricalOfficer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(electricalOfficer: v),
        ),
      ],
    );
  }
}
