class UpdateProjectRequest {
  const UpdateProjectRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.estimatedBudget,
    required this.contractualBudget,
    this.consultantId,
    this.endDate,
    this.startDate,
    this.contractorId,
    required this.status,
    required this.tagNames,
    this.currentStep,
    this.projectCode,
    this.brandId,
    this.productId,
    this.sizeMLId,
    this.productionLineId,
    this.civilEngineerId,
    this.architecturalEngineerId,
    this.electricalEngineerId,
    this.mechanicalEngineerId,
    this.surveyEngineerId,
    this.agriculturalEngineerId,
    this.generalEngineerId,
    this.supervisionEngineerId,
    this.supervisionConsultantId,
    this.projectManagementConsultantId,
    this.architecturalOfficerId,
    this.mechanicalOfficerId,
    this.electricalOfficerId,
    this.receiveBusinessId,
    this.documentsAdoptionId,
    this.executiveBoardsAdoptionId,
    this.materialsAdoptionId,
    this.subcontractorAdoptionId,
    this.materialsReceiveAndInspectId,
    this.informationRequestId,
    this.siteWorkInstructionsId,
    this.paymentCertificateAdoptionId,
    this.siteObservationReportId,
    this.nonConformanceReportId,
  });

  final String id;
  final String title;
  final String description;
  final String ownerId;
  final double estimatedBudget;
  final double contractualBudget;
  final String? consultantId;
  final String? endDate;
  final String? startDate;
  final String? contractorId;
  final int status;
  final List<String> tagNames;
  final Map<String, dynamic>? currentStep;
  final String? projectCode;
  final String? brandId;
  final String? productId;
  final String? sizeMLId;
  final String? productionLineId;
  final String? civilEngineerId;
  final String? architecturalEngineerId;
  final String? electricalEngineerId;
  final String? mechanicalEngineerId;
  final String? surveyEngineerId;
  final String? agriculturalEngineerId;
  final String? generalEngineerId;
  final String? supervisionEngineerId;
  final String? supervisionConsultantId;
  final String? projectManagementConsultantId;
  final String? architecturalOfficerId;
  final String? mechanicalOfficerId;
  final String? electricalOfficerId;
  final String? receiveBusinessId;
  final String? documentsAdoptionId;
  final String? executiveBoardsAdoptionId;
  final String? materialsAdoptionId;
  final String? subcontractorAdoptionId;
  final String? materialsReceiveAndInspectId;
  final String? informationRequestId;
  final String? siteWorkInstructionsId;
  final String? paymentCertificateAdoptionId;
  final String? siteObservationReportId;
  final String? nonConformanceReportId;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'estimatedBudget': estimatedBudget,
      'contractualBudget': contractualBudget,
      'status': status,
      'tagNames': tagNames,
    };

    void put(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      json[key] = value is String ? value.trim() : value;
    }

    put('endDate', endDate);
    put('startDate', startDate);
    put('projectCode', projectCode);
    put('brandId', brandId);
    put('productId', productId);
    put('sizeMLId', sizeMLId);
    put('productionLineId', productionLineId);
    if (currentStep != null) json['currentStep'] = currentStep;

    put('consultantId', consultantId);
    put('contractorId', contractorId);

    put('civilEngineerId', civilEngineerId);
    put('architecturalEngineerId', architecturalEngineerId);
    put('electricalEngineerId', electricalEngineerId);
    put('mechanicalEngineerId', mechanicalEngineerId);
    put('surveyEngineerId', surveyEngineerId);
    put('agriculturalEngineerId', agriculturalEngineerId);
    put('generalEngineerId', generalEngineerId);
    put('supervisionEngineerId', supervisionEngineerId);
    put('supervisionConsultantId', supervisionConsultantId);
    put('projectManagementConsultantId', projectManagementConsultantId);
    put('architecturalOfficerId', architecturalOfficerId);
    put('mechanicalOfficerId', mechanicalOfficerId);
    put('electricalOfficerId', electricalOfficerId);
    put('receiveBusinessId', receiveBusinessId);
    put('documentsAdoptionId', documentsAdoptionId);
    put('executiveBoardsAdoptionId', executiveBoardsAdoptionId);
    put('materialsAdoptionId', materialsAdoptionId);
    put('subcontractorAdoptionId', subcontractorAdoptionId);
    put('materialsReceiveAndInspectId', materialsReceiveAndInspectId);
    put('informationRequestId', informationRequestId);
    put('siteWorkInstructionsId', siteWorkInstructionsId);
    put('paymentCertificateAdoptionId', paymentCertificateAdoptionId);
    put('siteObservationReportId', siteObservationReportId);
    put('nonConformanceReportId', nonConformanceReportId);

    return json;
  }
}
