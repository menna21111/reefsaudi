import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/utils/app_string.dart';
import '../../cubit/edit_project_state.dart';

/// Returns translated labels of required add-project fields that are still empty.
class AddProjectFormValidator {
  AddProjectFormValidator._();

  static List<String> missingLabels(EditProjectFormData form) {
    final missing = <String>[];

    void text(String label, String value) {
      if (value.trim().isEmpty) missing.add(label);
    }

    void selection(String label, SelectionValue value) {
      final id = value.id?.trim();
      if (id == null || id.isEmpty) missing.add(label);
    }

    text(AppString.projectTitleLabel.tr(), form.title);
    selection(AppString.projectResponsible.tr(), form.owner);
    selection(AppString.generalConsultant.tr(), form.consultant);
    selection(AppString.contractor.tr(), form.contractor);
    text(AppString.description.tr(), form.description);

    if (form.startDate == null) {
      missing.add(AppString.projectStartDate.tr());
    }
    if (form.endDate == null) {
      missing.add(AppString.expectedProjectEndDate.tr());
    }

    text(AppString.contractualBudget.tr(), form.contractualBudget);
    text(AppString.estimatedBudget.tr(), form.estimatedBudget);

    if (form.phaseKey == null || form.phaseKey!.trim().isEmpty) {
      missing.add(AppString.projectPhaseLabel.tr());
    }
    if (form.phaseJoinDate == null) {
      missing.add(AppString.phaseJoinDate.tr());
    }
    if (form.statusKey == null || form.statusKey!.trim().isEmpty) {
      missing.add(AppString.projectStatus.tr());
    }

    selection(AppString.sector.tr(), form.sector);
    selection(AppString.region.tr(), form.region);
    selection(AppString.projectTypeLabel.tr(), form.projectType);
    selection(AppString.productionLine.tr(), form.productionLine);
    text(AppString.projectCode.tr(), form.projectCode);

    selection(AppString.supervisionConsultant.tr(), form.supervisionConsultant);
    selection(AppString.supervisionEngineer.tr(), form.supervisionEngineer);
    selection(AppString.civilEngineer.tr(), form.civilEngineer);
    selection(AppString.architecturalEngineer.tr(), form.architecturalEngineer);
    selection(AppString.electricalEngineer.tr(), form.electricalEngineer);
    selection(AppString.mechanicalEngineer.tr(), form.mechanicalEngineer);
    selection(AppString.surveyEngineer.tr(), form.surveyEngineer);
    selection(AppString.agriculturalEngineer.tr(), form.agriculturalEngineer);
    selection(AppString.generalEngineer.tr(), form.generalEngineer);

    selection(AppString.pmConsultant.tr(), form.projectManagementConsultant);
    selection(AppString.architecturalOfficer.tr(), form.architecturalOfficer);
    selection(AppString.mechanicalOfficer.tr(), form.mechanicalOfficer);
    selection(AppString.electricalOfficer.tr(), form.electricalOfficer);

    return missing;
  }

  static String toastMessage(List<String> missing) {
    if (missing.isEmpty) return AppString.fillRequiredFields.tr();
    final preview = missing.take(4).join('، ');
    final suffix = missing.length > 4 ? ' ...' : '';
    return '${AppString.missingFields.tr()}: $preview$suffix';
  }
}
