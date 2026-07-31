import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/network/account_user_type.dart';
import '../../../../../core/utils/app_string.dart';
import '../../cubit/edit_project_state.dart';
import 'edit_project_account_dropdown.dart';
import 'edit_project_section_card.dart';

class EditProjectSupervisionSection extends StatelessWidget {
  const EditProjectSupervisionSection({
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
      icon: Icons.engineering_outlined,
      title: AppString.supervisionManagementSection.tr(),
      children: [
        EditProjectAccountDropdown(
          title: AppString.supervisionConsultant.tr(),
          value: form.supervisionConsultant,
          required: requiredFields,
          showValidationError: showValidationErrors,
          userType: AccountUserType.consultant,
          map: (v) => form.copyWith(supervisionConsultant: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.supervisionEngineer.tr(),
          value: form.supervisionEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(supervisionEngineer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.civilEngineer.tr(),
          value: form.civilEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(civilEngineer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.architecturalEngineer.tr(),
          value: form.architecturalEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(architecturalEngineer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.electricalEngineer.tr(),
          value: form.electricalEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(electricalEngineer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.mechanicalEngineer.tr(),
          value: form.mechanicalEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(mechanicalEngineer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.surveyEngineer.tr(),
          value: form.surveyEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(surveyEngineer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.agriculturalEngineer.tr(),
          value: form.agriculturalEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(agriculturalEngineer: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.generalEngineer.tr(),
          value: form.generalEngineer,
          required: requiredFields,
          showValidationError: showValidationErrors,
          map: (v) => form.copyWith(generalEngineer: v),
        ),
      ],
    );
  }
}
