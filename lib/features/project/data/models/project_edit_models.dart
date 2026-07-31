class ProjectEditDto {
  final String id;
  final String title;
  final String description;
  final String? projectCode;
  final String ownerId;
  final String ownerName;
  final String consultantId;
  final String consultantName;
  final String contractorId;
  final String contractorName;
  final int status;
  final double contractualBudget;
  final double estimatedBudget;
  final String startDate;
  final String endDate;
  final String brandId;
  final String brandName;
  final String productId;
  final String productName;
  final String sizeMLId;
  final String sizeMLName;
  final String? productionLineId;
  final String? productionLineName;
  final String? civilEngineerId;
  final String? civilEngineerName;
  final String? architecturalEngineerId;
  final String? architecturalEngineerName;
  final String? electricalEngineerId;
  final String? electricalEngineerName;
  final String? mechanicalEngineerId;
  final String? mechanicalEngineerName;
  final String? surveyEngineerId;
  final String? surveyEngineerName;
  final String? agriculturalEngineerId;
  final String? agriculturalEngineerName;
  final String? generalEngineerId;
  final String? generalEngineerName;
  final String? supervisionEngineerId;
  final String? supervisionEngineerName;
  final String? supervisionConsultantId;
  final String? supervisionConsultantName;
  final String? projectManagementConsultantId;
  final String? projectManagementConsultantName;
  final String? architecturalOfficerId;
  final String? architecturalOfficerName;
  final String? mechanicalOfficerId;
  final String? mechanicalOfficerName;
  final String? electricalOfficerId;
  final String? electricalOfficerName;
  final String? receiveBusinessId;
  final String? receiveBusinessName;
  final String? documentsAdoptionId;
  final String? documentsAdoptionName;
  final String? executiveBoardsAdoptionId;
  final String? executiveBoardsAdoptionName;
  final String? materialsAdoptionId;
  final String? materialsAdoptionName;
  final String? subcontractorAdoptionId;
  final String? subcontractorAdoptionName;
  final String? materialsReceiveAndInspectId;
  final String? materialsReceiveAndInspectName;
  final String? informationRequestId;
  final String? informationRequestName;
  final String? siteWorkInstructionsId;
  final String? siteWorkInstructionsName;
  final String? paymentCertificateAdoptionId;
  final String? paymentCertificateAdoptionName;
  final String? siteObservationReportId;
  final String? siteObservationReportName;
  final String? nonConformanceReportId;
  final String? nonConformanceReportName;
  final ProjectCurrentStepDto? currentStep;
  final List<String> tagNames;

  const ProjectEditDto({
    required this.id,
    required this.title,
    required this.description,
    this.projectCode,
    required this.ownerId,
    required this.ownerName,
    required this.consultantId,
    required this.consultantName,
    required this.contractorId,
    required this.contractorName,
    required this.status,
    required this.contractualBudget,
    required this.estimatedBudget,
    required this.startDate,
    required this.endDate,
    required this.brandId,
    required this.brandName,
    required this.productId,
    required this.productName,
    required this.sizeMLId,
    required this.sizeMLName,
    this.productionLineId,
    this.productionLineName,
    this.civilEngineerId,
    this.civilEngineerName,
    this.architecturalEngineerId,
    this.architecturalEngineerName,
    this.electricalEngineerId,
    this.electricalEngineerName,
    this.mechanicalEngineerId,
    this.mechanicalEngineerName,
    this.surveyEngineerId,
    this.surveyEngineerName,
    this.agriculturalEngineerId,
    this.agriculturalEngineerName,
    this.generalEngineerId,
    this.generalEngineerName,
    this.supervisionEngineerId,
    this.supervisionEngineerName,
    this.supervisionConsultantId,
    this.supervisionConsultantName,
    this.projectManagementConsultantId,
    this.projectManagementConsultantName,
    this.architecturalOfficerId,
    this.architecturalOfficerName,
    this.mechanicalOfficerId,
    this.mechanicalOfficerName,
    this.electricalOfficerId,
    this.electricalOfficerName,
    this.receiveBusinessId,
    this.receiveBusinessName,
    this.documentsAdoptionId,
    this.documentsAdoptionName,
    this.executiveBoardsAdoptionId,
    this.executiveBoardsAdoptionName,
    this.materialsAdoptionId,
    this.materialsAdoptionName,
    this.subcontractorAdoptionId,
    this.subcontractorAdoptionName,
    this.materialsReceiveAndInspectId,
    this.materialsReceiveAndInspectName,
    this.informationRequestId,
    this.informationRequestName,
    this.siteWorkInstructionsId,
    this.siteWorkInstructionsName,
    this.paymentCertificateAdoptionId,
    this.paymentCertificateAdoptionName,
    this.siteObservationReportId,
    this.siteObservationReportName,
    this.nonConformanceReportId,
    this.nonConformanceReportName,
    this.currentStep,
    this.tagNames = const [],
  });

  factory ProjectEditDto.fromJson(Map<String, dynamic> json) {
    return ProjectEditDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString().trim() ?? '',
      description: json['description']?.toString() ?? '',
      projectCode: json['projectCode']?.toString() ??
          json['code']?.toString(),
      ownerId: json['ownerId']?.toString() ?? '',
      ownerName: json['ownerName']?.toString() ?? '',
      consultantId: json['consultantId']?.toString() ?? '',
      consultantName: json['consultantName']?.toString() ?? '',
      contractorId: json['contractorId']?.toString() ?? '',
      contractorName: json['contractorName']?.toString() ?? '',
      status: _toInt(json['status']),
      contractualBudget: _toDouble(
        json['contractualBudget'] ?? json['quantity'],
      ),
      estimatedBudget: _toDouble(json['estimatedBudget']),
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      brandId: json['brandId']?.toString() ?? '',
      brandName: json['brandName']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      sizeMLId: json['sizeMLId']?.toString() ?? '',
      sizeMLName: json['sizeMLName']?.toString() ?? '',
      productionLineId: json['productionLineId']?.toString(),
      productionLineName: json['productionLineName']?.toString(),
      civilEngineerId: json['civilEngineerId']?.toString(),
      civilEngineerName: json['civilEngineerName']?.toString(),
      architecturalEngineerId: json['architecturalEngineerId']?.toString(),
      architecturalEngineerName: json['architecturalEngineerName']?.toString(),
      electricalEngineerId: json['electricalEngineerId']?.toString(),
      electricalEngineerName: json['electricalEngineerName']?.toString(),
      mechanicalEngineerId: json['mechanicalEngineerId']?.toString(),
      mechanicalEngineerName: json['mechanicalEngineerName']?.toString(),
      surveyEngineerId: json['surveyEngineerId']?.toString(),
      surveyEngineerName: json['surveyEngineerName']?.toString(),
      agriculturalEngineerId: json['agriculturalEngineerId']?.toString(),
      agriculturalEngineerName: json['agriculturalEngineerName']?.toString(),
      generalEngineerId: json['generalEngineerId']?.toString(),
      generalEngineerName: json['generalEngineerName']?.toString(),
      supervisionEngineerId: json['supervisionEngineerId']?.toString(),
      supervisionEngineerName: json['supervisionEngineerName']?.toString(),
      supervisionConsultantId: json['supervisionConsultantId']?.toString(),
      supervisionConsultantName: json['supervisionConsultantName']?.toString(),
      projectManagementConsultantId:
          json['projectManagementConsultantId']?.toString(),
      projectManagementConsultantName:
          json['projectManagementConsultantName']?.toString(),
      architecturalOfficerId: json['architecturalOfficerId']?.toString(),
      architecturalOfficerName: json['architecturalOfficerName']?.toString(),
      mechanicalOfficerId: json['mechanicalOfficerId']?.toString(),
      mechanicalOfficerName: json['mechanicalOfficerName']?.toString(),
      electricalOfficerId: json['electricalOfficerId']?.toString(),
      electricalOfficerName: json['electricalOfficerName']?.toString(),
      receiveBusinessId: json['receiveBusinessId']?.toString(),
      receiveBusinessName: json['receiveBusinessName']?.toString(),
      documentsAdoptionId: json['documentsAdoptionId']?.toString(),
      documentsAdoptionName: json['documentsAdoptionName']?.toString(),
      executiveBoardsAdoptionId: json['executiveBoardsAdoptionId']?.toString(),
      executiveBoardsAdoptionName:
          json['executiveBoardsAdoptionName']?.toString(),
      materialsAdoptionId: json['materialsAdoptionId']?.toString(),
      materialsAdoptionName: json['materialsAdoptionName']?.toString(),
      subcontractorAdoptionId: json['subcontractorAdoptionId']?.toString(),
      subcontractorAdoptionName: json['subcontractorAdoptionName']?.toString(),
      materialsReceiveAndInspectId:
          json['materialsReceiveAndInspectId']?.toString(),
      materialsReceiveAndInspectName:
          json['materialsReceiveAndInspectName']?.toString(),
      informationRequestId: json['informationRequestId']?.toString(),
      informationRequestName: json['informationRequestName']?.toString(),
      siteWorkInstructionsId: json['siteWorkInstructionsId']?.toString(),
      siteWorkInstructionsName: json['siteWorkInstructionsName']?.toString(),
      paymentCertificateAdoptionId:
          json['paymentCertificateAdoptionId']?.toString(),
      paymentCertificateAdoptionName:
          json['paymentCertificateAdoptionName']?.toString(),
      siteObservationReportId: json['siteObservationReportId']?.toString(),
      siteObservationReportName: json['siteObservationReportName']?.toString(),
      nonConformanceReportId: json['nonConformanceReportId']?.toString(),
      nonConformanceReportName: json['nonConformanceReportName']?.toString(),
      currentStep: json['currentStep'] is Map<String, dynamic>
          ? ProjectCurrentStepDto.fromJson(
              json['currentStep'] as Map<String, dynamic>,
            )
          : null,
      tagNames: _parseTagNames(json['tagNames']),
    );
  }
}

List<String> _parseTagNames(dynamic raw) {
  if (raw is! List) return const [];
  return raw.map((item) => item.toString()).where((item) => item.isNotEmpty).toList();
}

class ProjectCurrentStepDto {
  final int type;
  final String startedAt;
  final int? durationInDays;
  final dynamic progressRatio;
  final dynamic status;

  const ProjectCurrentStepDto({
    required this.type,
    required this.startedAt,
    this.durationInDays,
    this.progressRatio,
    this.status,
  });

  factory ProjectCurrentStepDto.fromJson(Map<String, dynamic> json) {
    return ProjectCurrentStepDto(
      type: _toInt(json['type']),
      startedAt: json['startedAt']?.toString() ?? '',
      durationInDays: json['durationInDays'] is int
          ? json['durationInDays'] as int
          : int.tryParse(json['durationInDays']?.toString() ?? ''),
      progressRatio: json['progressRatio'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startedAt': startedAt,
      if (durationInDays != null) 'durationInDays': durationInDays,
      'progressRatio': progressRatio,
      'status': status,
    };
  }
}

class DxListItemDto {
  final String id;
  final String title;

  const DxListItemDto({required this.id, required this.title});

  factory DxListItemDto.fromJson(Map<String, dynamic> json) {
    return DxListItemDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}

List<DxListItemDto> parseDxListItems(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(DxListItemDto.fromJson)
      .where((item) => item.id.isNotEmpty)
      .toList();
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? parseApiDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

/// Static phase options for the edit form.
const projectPhaseOptions = [
  'project_phase_tender',
  'project_phase_tender_processing',
  'project_phase_accreditation',
  'project_phase_review_committee',
  'project_phase_contract_signing',
  'project_phase_kickoff_meeting',
  'project_phase_land_delivery',
  'project_phase_start',
  'project_phase_end',
  'project_phase_procurement',
];

/// Static status options for the edit form.
const projectStatusOptions = [
  'project_status_started',
  'project_status_awarded',
  'project_status_signed',
  'project_status_review_committee',
  'project_status_accreditation',
  'project_status_ended',
  'project_status_tender',
];
