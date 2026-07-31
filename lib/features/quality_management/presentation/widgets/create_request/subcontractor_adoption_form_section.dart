import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import 'quality_file_picker_field.dart';

class SubcontractorAdoptionFormSection extends StatelessWidget {
  const SubcontractorAdoptionFormSection({
    super.key,
    required this.subcontractorNameController,
    required this.subcontractorEmploymentController,
    required this.subcontractorExperienceController,
    required this.subcontractorExperienceInsideKsaController,
    required this.communicationResponsibleController,
    required this.communicationResponsiblePhoneNumberController,
    required this.subcontractorEmploymentInsideThisProjectController,
    required this.otherLicensesController,
    required this.subcontractorLocationController,
    required this.commercialLicenseAttachmentPath,
    required this.companyProfileAndCatalogsAttachmentPath,
    required this.generalAuthorityForInvestmentCertificateAttachmentPath,
    required this.vatRegistrationCertificateAttachmentPath,
    required this.validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath,
    required this.validIndustrialOrCommercialLicenseAttachmentPath,
    required this.validSaudizationCertificateAttachmentPath,
    required this.validSocialInsuranceCertificateAttachmentPath,
    required this.onCommercialLicenseAttachmentPicked,
    required this.onCompanyProfileAndCatalogsAttachmentPicked,
    required this.onGeneralAuthorityForInvestmentCertificateAttachmentPicked,
    required this.onVatRegistrationCertificateAttachmentPicked,
    required this.onValidGeneralAuthorityForZakatAndTaxCertificateAttachmentPicked,
    required this.onValidIndustrialOrCommercialLicenseAttachmentPicked,
    required this.onValidSaudizationCertificateAttachmentPicked,
    required this.onValidSocialInsuranceCertificateAttachmentPicked,
    required this.inputDecoration,
  });

  final TextEditingController subcontractorNameController;
  final TextEditingController subcontractorEmploymentController;
  final TextEditingController subcontractorExperienceController;
  final TextEditingController subcontractorExperienceInsideKsaController;
  final TextEditingController communicationResponsibleController;
  final TextEditingController communicationResponsiblePhoneNumberController;
  final TextEditingController subcontractorEmploymentInsideThisProjectController;
  final TextEditingController otherLicensesController;
  final TextEditingController subcontractorLocationController;
  final String? commercialLicenseAttachmentPath;
  final String? companyProfileAndCatalogsAttachmentPath;
  final String? generalAuthorityForInvestmentCertificateAttachmentPath;
  final String? vatRegistrationCertificateAttachmentPath;
  final String? validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath;
  final String? validIndustrialOrCommercialLicenseAttachmentPath;
  final String? validSaudizationCertificateAttachmentPath;
  final String? validSocialInsuranceCertificateAttachmentPath;
  final ValueChanged<String> onCommercialLicenseAttachmentPicked;
  final ValueChanged<String> onCompanyProfileAndCatalogsAttachmentPicked;
  final ValueChanged<String>
      onGeneralAuthorityForInvestmentCertificateAttachmentPicked;
  final ValueChanged<String> onVatRegistrationCertificateAttachmentPicked;
  final ValueChanged<String>
      onValidGeneralAuthorityForZakatAndTaxCertificateAttachmentPicked;
  final ValueChanged<String>
      onValidIndustrialOrCommercialLicenseAttachmentPicked;
  final ValueChanged<String> onValidSaudizationCertificateAttachmentPicked;
  final ValueChanged<String> onValidSocialInsuranceCertificateAttachmentPicked;
  final InputDecoration Function(String label) inputDecoration;

  Widget _field(
    BuildContext context, {
    required TextEditingController controller,
    required String labelKey,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: FormLayout.alignOf(context),
      textDirection: FormLayout.directionOf(context),
      decoration: inputDecoration(labelKey.tr()),
    );
  }

  Widget _file({
    required String labelKey,
    required String? path,
    required ValueChanged<String> onPicked,
  }) {
    return QualityFilePickerField(
      label: labelKey.tr(),
      filePath: path,
      onPicked: onPicked,
      onClear: path == null ? null : () => onPicked(''),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppString.subcontractorAdoptionDetails.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: subcontractorNameController,
          labelKey: AppString.subcontractorName,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: subcontractorEmploymentController,
          labelKey: AppString.subcontractorEmployment,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: subcontractorExperienceController,
          labelKey: AppString.subcontractorExperience,
          minLines: 2,
          maxLines: 4,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: subcontractorExperienceInsideKsaController,
          labelKey: AppString.subcontractorExperienceInsideKsa,
          minLines: 2,
          maxLines: 4,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: communicationResponsibleController,
          labelKey: AppString.communicationResponsible,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: communicationResponsiblePhoneNumberController,
          labelKey: AppString.communicationResponsiblePhoneNumber,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: subcontractorEmploymentInsideThisProjectController,
          labelKey: AppString.subcontractorEmploymentInsideThisProject,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: otherLicensesController,
          labelKey: AppString.otherLicenses,
          minLines: 2,
          maxLines: 4,
        ),
        SizedBox(height: 14.h),
        _field(
          context,
          controller: subcontractorLocationController,
          labelKey: AppString.subcontractorLocation,
        ),
        SizedBox(height: 20.h),
        _file(
          labelKey: AppString.commercialLicenseAttachment,
          path: commercialLicenseAttachmentPath,
          onPicked: onCommercialLicenseAttachmentPicked,
        ),
        SizedBox(height: 14.h),
        _file(
          labelKey: AppString.companyProfileAndCatalogsAttachment,
          path: companyProfileAndCatalogsAttachmentPath,
          onPicked: onCompanyProfileAndCatalogsAttachmentPicked,
        ),
        SizedBox(height: 14.h),
        _file(
          labelKey:
              AppString.generalAuthorityForInvestmentCertificateAttachment,
          path: generalAuthorityForInvestmentCertificateAttachmentPath,
          onPicked: onGeneralAuthorityForInvestmentCertificateAttachmentPicked,
        ),
        SizedBox(height: 14.h),
        _file(
          labelKey: AppString.vatRegistrationCertificateAttachment,
          path: vatRegistrationCertificateAttachmentPath,
          onPicked: onVatRegistrationCertificateAttachmentPicked,
        ),
        SizedBox(height: 14.h),
        _file(
          labelKey: AppString
              .validGeneralAuthorityForZakatAndTaxCertificateAttachment,
          path: validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath,
          onPicked:
              onValidGeneralAuthorityForZakatAndTaxCertificateAttachmentPicked,
        ),
        SizedBox(height: 14.h),
        _file(
          labelKey: AppString.validIndustrialOrCommercialLicenseAttachment,
          path: validIndustrialOrCommercialLicenseAttachmentPath,
          onPicked: onValidIndustrialOrCommercialLicenseAttachmentPicked,
        ),
        SizedBox(height: 14.h),
        _file(
          labelKey: AppString.validSaudizationCertificateAttachment,
          path: validSaudizationCertificateAttachmentPath,
          onPicked: onValidSaudizationCertificateAttachmentPicked,
        ),
        SizedBox(height: 14.h),
        _file(
          labelKey: AppString.validSocialInsuranceCertificateAttachment,
          path: validSocialInsuranceCertificateAttachmentPath,
          onPicked: onValidSocialInsuranceCertificateAttachmentPicked,
        ),
      ],
    );
  }
}
