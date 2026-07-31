import '../../../../core/utils/app_string.dart';

abstract final class ProjectTemplateRequestTypes {
  static const Map<int, String> titleKeys = {
    0: AppString.requestTypeWorkInspection,
    1: AppString.requestTypeDocumentApproval,
    2: AppString.requestTypeShopDrawingApproval,
    3: AppString.requestTypeMaterialApproval,
    4: AppString.requestTypeSubcontractorApproval,
    5: AppString.requestTypeMaterialInspection,
    6: AppString.requestTypeInformationRequest,
    7: AppString.requestTypeSiteInstruction,
    8: AppString.requestTypePaymentApproval,
    9: AppString.requestTypeSiteObservation,
    10: AppString.requestTypeNonConformance,
  };

  static String titleKey(int value) =>
      titleKeys[value] ?? AppString.unknownRequestType;
}

abstract final class TemplateTaskAssignTypes {
  static const Map<int, String> titleKeys = {
    0: AppString.assignTypeNone,
    1: AppString.assignTypeContractor,
    2: AppString.assignTypeSiteEngineer,
    3: AppString.assignTypeOfficeEngineer,
    4: AppString.assignTypeGeneralSupervision,
    5: AppString.assignTypePmSupervision,
  };

  static String titleKey(int value) =>
      titleKeys[value] ?? AppString.assignTypeNone;
}
