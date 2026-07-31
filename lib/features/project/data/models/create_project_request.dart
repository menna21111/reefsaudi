import 'package:dio/dio.dart';

class CreateProjectRequest {
  const CreateProjectRequest({
    this.projectType = 0,
    required this.title,
    this.description,
    this.ownerId,
    this.consultantId,
    this.contractorId,
    this.contractualBudget,
    this.estimatedBudget,
    this.brandId,
    this.productId,
    this.sizeMLId,
    this.productionLineId,
    this.projectCode,
    this.supervisionConsultantId,
    this.supervisionEngineerId,
    this.civilEngineerId,
    this.architecturalEngineerId,
    this.electricalEngineerId,
    this.mechanicalEngineerId,
    this.surveyEngineerId,
    this.agriculturalEngineerId,
    this.generalEngineerId,
    this.projectManagementConsultantId,
    this.architecturalOfficerId,
    this.mechanicalOfficerId,
    this.electricalOfficerId,
    this.subcontractorAdoptionId,
    this.receiveBusinessId,
    this.documentsAdoptionId,
    this.executiveBoardsAdoptionId,
    this.materialsAdoptionId,
    this.materialsReceiveAndInspectId,
    this.informationRequestId,
    this.paymentCertificateAdoptionId,
    this.siteWorkInstructionsId,
    this.siteObservationReportId,
    this.nonConformanceReportId,
    this.startDate,
  });

  final int projectType;
  final String title;
  final String? description;
  final String? ownerId;
  final String? consultantId;
  final String? contractorId;
  final String? contractualBudget;
  final String? estimatedBudget;
  final String? brandId;
  final String? productId;
  final String? sizeMLId;
  final String? productionLineId;
  final String? projectCode;
  final String? supervisionConsultantId;
  final String? supervisionEngineerId;
  final String? civilEngineerId;
  final String? architecturalEngineerId;
  final String? electricalEngineerId;
  final String? mechanicalEngineerId;
  final String? surveyEngineerId;
  final String? agriculturalEngineerId;
  final String? generalEngineerId;
  final String? projectManagementConsultantId;
  final String? architecturalOfficerId;
  final String? mechanicalOfficerId;
  final String? electricalOfficerId;
  final String? subcontractorAdoptionId;
  final String? receiveBusinessId;
  final String? documentsAdoptionId;
  final String? executiveBoardsAdoptionId;
  final String? materialsAdoptionId;
  final String? materialsReceiveAndInspectId;
  final String? informationRequestId;
  final String? paymentCertificateAdoptionId;
  final String? siteWorkInstructionsId;
  final String? siteObservationReportId;
  final String? nonConformanceReportId;
  final String? startDate;

  FormData toFormData() {
    final map = <String, dynamic>{
      'projectType': projectType.toString(),
      'title': title,
    };

    void put(String key, dynamic value) {
      if (value == null) return;
      final text = value.toString().trim();
      if (text.isEmpty) return;
      map[key] = text;
    }

    put('description', description);
    put('ownerId', ownerId);
    put('consultantId', consultantId);
    put('contractorId', contractorId);
    put('contractualBudget', contractualBudget);
    put('estimatedBudget', estimatedBudget);
    put('brandId', brandId);
    put('productId', productId);
    put('sizeMLId', sizeMLId);
    put('productionLineId', productionLineId);
    put('projectCode', projectCode);
    put('supervisionConsultantId', supervisionConsultantId);
    put('supervisionEngineerId', supervisionEngineerId);
    put('civilEngineerId', civilEngineerId);
    put('architecturalEngineerId', architecturalEngineerId);
    put('electricalEngineerId', electricalEngineerId);
    put('mechanicalEngineerId', mechanicalEngineerId);
    put('surveyEngineerId', surveyEngineerId);
    put('agriculturalEngineerId', agriculturalEngineerId);
    put('generalEngineerId', generalEngineerId);
    put('projectManagementConsultantId', projectManagementConsultantId);
    put('architecturalOfficerId', architecturalOfficerId);
    put('mechanicalOfficerId', mechanicalOfficerId);
    put('electricalOfficerId', electricalOfficerId);
    put('subcontractorAdoptionId', subcontractorAdoptionId);
    put('receiveBusinessId', receiveBusinessId);
    put('documentsAdoptionId', documentsAdoptionId);
    put('executiveBoardsAdoptionId', executiveBoardsAdoptionId);
    put('materialsAdoptionId', materialsAdoptionId);
    put('materialsReceiveAndInspectId', materialsReceiveAndInspectId);
    put('informationRequestId', informationRequestId);
    put('paymentCertificateAdoptionId', paymentCertificateAdoptionId);
    put('siteWorkInstructionsId', siteWorkInstructionsId);
    put('siteObservationReportId', siteObservationReportId);
    put('nonConformanceReportId', nonConformanceReportId);
    put('startDate', startDate);

    return FormData.fromMap(map);
  }
}
