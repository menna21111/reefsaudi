import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_string.dart';
import '../../cubit/edit_project_state.dart';
import 'edit_project_account_dropdown.dart';
import 'edit_project_section_card.dart';
import 'edit_project_template_dropdown.dart';

class EditProjectFormsSection extends StatelessWidget {
  const EditProjectFormsSection({super.key, required this.form});

  final EditProjectFormData form;

  @override
  Widget build(BuildContext context) {
    return EditProjectSectionCard(
      icon: Icons.description_outlined,
      title: AppString.formsManagementSection.tr(),
      children: [
        EditProjectTemplateDropdown(
          title: AppString.formSubcontractorApproval.tr(),
          value: form.subcontractorAdoption,
          map: (v) => form.copyWith(subcontractorAdoption: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formWorkHandover.tr(),
          value: form.receiveBusiness,
          map: (v) => form.copyWith(receiveBusiness: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formDocumentApproval.tr(),
          value: form.documentsAdoption,
          map: (v) => form.copyWith(documentsAdoption: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formShopDrawingsApproval.tr(),
          value: form.executiveBoardsAdoption,
          map: (v) => form.copyWith(executiveBoardsAdoption: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formMaterialApproval.tr(),
          value: form.materialsAdoption,
          map: (v) => form.copyWith(materialsAdoption: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formMaterialReceiving.tr(),
          value: form.materialsReceiveAndInspect,
          map: (v) => form.copyWith(materialsReceiveAndInspect: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formRequestForInformation.tr(),
          value: form.informationRequest,
          map: (v) => form.copyWith(informationRequest: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formPaymentCertificate.tr(),
          value: form.paymentCertificateAdoption,
          map: (v) => form.copyWith(paymentCertificateAdoption: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formSiteWorkInstructions.tr(),
          value: form.siteWorkInstructions,
          map: (v) => form.copyWith(siteWorkInstructions: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formSiteObservations.tr(),
          value: form.siteObservationReport,
          map: (v) => form.copyWith(siteObservationReport: v),
        ),
        const EditProjectFieldGap(),
        EditProjectTemplateDropdown(
          title: AppString.formNonConformance.tr(),
          value: form.nonConformanceReport,
          map: (v) => form.copyWith(nonConformanceReport: v),
        ),
      ],
    );
  }
}
