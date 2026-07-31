import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/app_string.dart';
import '../../../auth/data/models/profile_model.dart';

class QualityOption<T> {
  const QualityOption({required this.value, required this.labelKey});

  final T value;
  final String labelKey;

  String get label => labelKey.tr();
}

abstract final class QualityRequestTypePolicy {
  /// Admin: تعليمات العمل بالموقع، ملاحظات الموقع، عدم المطابقة
  static const List<int> adminTypes = [7, 9, 10];

  /// باقي المستخدمين: كل الأنواع ما عدا 7 و 9 و 10 (يشمل اعتماد المستخلصات = 8)
  static const List<int> standardTypes = [0, 1, 2, 3, 4, 5, 6, 8];

  /// ترتيب العرض في الويب لغير الـ admin
  static const List<int> standardTypesDisplayOrder = [0, 5, 1, 8, 4, 2, 6, 3];

  static List<QualityOption<int>> allowedFor(ProfileModel? profile) {
    if (_isAdmin(profile)) {
      return QualityCreatableRequestTypes.items
          .where((option) => adminTypes.contains(option.value))
          .toList();
    }

    final byValue = {
      for (final option in QualityCreatableRequestTypes.items)
        option.value: option,
    };

    return standardTypesDisplayOrder
        .where(standardTypes.contains)
        .map((value) => byValue[value])
        .whereType<QualityOption<int>>()
        .toList();
  }

  static List<int> allowedValuesFor(ProfileModel? profile) {
    if (_isAdmin(profile)) return adminTypes;
    return standardTypes;
  }

  static int defaultTypeFor(ProfileModel? profile) {
    if (_isAdmin(profile)) {
      return adminTypes.isNotEmpty ? adminTypes.first : 7;
    }
    return standardTypesDisplayOrder.isNotEmpty
        ? standardTypesDisplayOrder.first
        : 0;
  }

  static bool _isAdmin(ProfileModel? profile) {
    if (profile == null) return false;
    return profile.roles.any((role) {
      final normalized = role.trim().toLowerCase();
      return normalized.contains('admin') ||
          role.contains('مدير') ||
          role.contains('مسؤول النظام');
    });
  }
}

abstract final class QualitySpecializationOptions {
  static const List<QualityOption<int>> items = [
    QualityOption(value: 0, labelKey: AppString.specializationGeneral),
    QualityOption(value: 1, labelKey: AppString.specializationSurvey),
    QualityOption(value: 2, labelKey: AppString.agriculturalEngineer),
    QualityOption(value: 3, labelKey: AppString.electricalEngineer),
    QualityOption(value: 4, labelKey: AppString.mechanicalEngineer),
    QualityOption(value: 5, labelKey: AppString.architecturalEngineer),
    QualityOption(value: 6, labelKey: AppString.civilEngineer),
  ];
}

abstract final class QualityCreatableRequestTypes {
  static const List<QualityOption<int>> items = [
    QualityOption(value: 0, labelKey: AppString.formWorkHandover),
    QualityOption(value: 1, labelKey: AppString.formDocumentApproval),
    QualityOption(value: 2, labelKey: AppString.formShopDrawingsApproval),
    QualityOption(value: 3, labelKey: AppString.formMaterialApproval),
    QualityOption(value: 4, labelKey: AppString.formSubcontractorApproval),
    QualityOption(value: 5, labelKey: AppString.formMaterialReceiving),
    QualityOption(value: 6, labelKey: AppString.formRequestForInformation),
    QualityOption(value: 7, labelKey: AppString.formSiteWorkInstructions),
    QualityOption(value: 8, labelKey: AppString.formPaymentCertificate),
    QualityOption(value: 9, labelKey: AppString.formSiteObservations),
    QualityOption(value: 10, labelKey: AppString.formNonConformance),
  ];

  static const Map<int, String> apiNames = {
    0: 'ReceiveBusiness',
    1: 'DocumentsAdoption',
    2: 'ExecutiveBoardsAdoption',
    3: 'MaterialsAdoption',
    4: 'SubcontractorAdoption',
    5: 'MaterialsReceiveAndInspect',
    6: 'InformationRequest',
    7: 'SiteWorkInstructions',
    8: 'PaymentCertificateAdoption',
    9: 'SiteObservationReport',
    10: 'NonConformanceReport',
  };

  static String apiNameFor(int requestType) =>
      apiNames[requestType] ?? 'ReceiveBusiness';

  static bool usesSupervisionForm(int requestType) =>
      requestType == 7 || requestType == 9 || requestType == 10;

  static bool usesReceiveBusinessForm(int requestType) => requestType == 0;

  static bool usesDocumentsAdoptionForm(int requestType) => requestType == 1;

  static bool usesMaterialsAdoptionForm(int requestType) => requestType == 3;

  static bool usesPaymentCertificateAdoptionForm(int requestType) =>
      requestType == 8;

  static bool usesAdoptionItemsForm(int requestType) =>
      usesDocumentsAdoptionForm(requestType) ||
      usesPaymentCertificateAdoptionForm(requestType);

  static bool usesMaterialsReceiveForm(int requestType) => requestType == 5;

  static bool usesSubcontractorAdoptionForm(int requestType) => requestType == 4;

  static bool usesExecutiveBoardAdoptionForm(int requestType) => requestType == 2;

  static bool usesInformationRequestForm(int requestType) => requestType == 6;

  static String detailsSectionKey(int requestType) {
    return switch (requestType) {
      0 => AppString.receiveBusinessDetails,
      1 => AppString.documentsAdoptionDetails,
      2 => AppString.executiveBoardAdoptionDetails,
      3 => AppString.materialsAdoptionDetails,
      4 => AppString.subcontractorAdoptionDetails,
      5 => AppString.materialsReceiveDetails,
      6 => AppString.informationRequestDetails,
      8 => AppString.paymentCertificateAdoptionDetails,
      7 => AppString.siteWorkInstructionsDetails,
      9 => AppString.siteObservationsDetails,
      10 => AppString.nonConformanceDetails,
      _ => AppString.generalData,
    };
  }
}
