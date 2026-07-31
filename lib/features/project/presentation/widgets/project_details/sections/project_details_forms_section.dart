import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_string.dart';
import '../../../cubit/edit_project_state.dart';
import '../../project_detail_field.dart';
import '../project_details_field_helpers.dart';

class ProjectDetailsFormsSection extends StatelessWidget {
  const ProjectDetailsFormsSection({super.key, required this.form});

  final EditProjectFormData form;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field(AppString.formSubcontractorApproval.tr(), form.subcontractorAdoption),
        const ProjectDetailFieldGap(),
        _field(AppString.formWorkHandover.tr(), form.receiveBusiness),
        const ProjectDetailFieldGap(),
        _field(AppString.formDocumentApproval.tr(), form.documentsAdoption),
        const ProjectDetailFieldGap(),
        _field(AppString.formShopDrawingsApproval.tr(), form.executiveBoardsAdoption),
        const ProjectDetailFieldGap(),
        _field(AppString.formMaterialApproval.tr(), form.materialsAdoption),
        const ProjectDetailFieldGap(),
        _field(AppString.formMaterialReceiving.tr(), form.materialsReceiveAndInspect),
        const ProjectDetailFieldGap(),
        _field(AppString.formRequestForInformation.tr(), form.informationRequest),
        const ProjectDetailFieldGap(),
        _field(AppString.formPaymentCertificate.tr(), form.paymentCertificateAdoption),
        const ProjectDetailFieldGap(),
        _field(AppString.formSiteWorkInstructions.tr(), form.siteWorkInstructions),
        const ProjectDetailFieldGap(),
        _field(AppString.formSiteObservations.tr(), form.siteObservationReport),
        const ProjectDetailFieldGap(),
        _field(AppString.formNonConformance.tr(), form.nonConformanceReport),
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
