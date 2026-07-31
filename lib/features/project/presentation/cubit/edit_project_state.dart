import 'package:equatable/equatable.dart';

import '../../data/models/project_edit_models.dart';

class SelectionValue extends Equatable {
  final String? id;
  final String? label;

  const SelectionValue({this.id, this.label});

  SelectionValue copyWith({String? id, String? label}) {
    return SelectionValue(
      id: id ?? this.id,
      label: label ?? this.label,
    );
  }

  @override
  List<Object?> get props => [id, label];
}

class EditProjectFormData extends Equatable {
  final String title;
  final String description;
  final String projectCode;
  final String contractualBudget;
  final String estimatedBudget;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? phaseJoinDate;
  final String? phaseKey;
  final String? statusKey;
  final SelectionValue owner;
  final SelectionValue consultant;
  final SelectionValue contractor;
  final SelectionValue sector;
  final SelectionValue region;
  final SelectionValue projectType;
  final SelectionValue productionLine;
  final int? phaseDurationInDays;
  final dynamic phaseProgressRatio;
  final dynamic phaseStatus;
  final SelectionValue supervisionConsultant;
  final SelectionValue supervisionEngineer;
  final SelectionValue civilEngineer;
  final SelectionValue architecturalEngineer;
  final SelectionValue electricalEngineer;
  final SelectionValue mechanicalEngineer;
  final SelectionValue surveyEngineer;
  final SelectionValue agriculturalEngineer;
  final SelectionValue generalEngineer;
  final SelectionValue projectManagementConsultant;
  final SelectionValue architecturalOfficer;
  final SelectionValue mechanicalOfficer;
  final SelectionValue electricalOfficer;
  final SelectionValue subcontractorAdoption;
  final SelectionValue receiveBusiness;
  final SelectionValue documentsAdoption;
  final SelectionValue executiveBoardsAdoption;
  final SelectionValue materialsAdoption;
  final SelectionValue materialsReceiveAndInspect;
  final SelectionValue informationRequest;
  final SelectionValue paymentCertificateAdoption;
  final SelectionValue siteWorkInstructions;
  final SelectionValue siteObservationReport;
  final SelectionValue nonConformanceReport;
  final List<String> tagNames;

  const EditProjectFormData({
    this.title = '',
    this.description = '',
    this.projectCode = '',
    this.contractualBudget = '',
    this.estimatedBudget = '',
    this.startDate,
    this.endDate,
    this.phaseJoinDate,
    this.phaseKey,
    this.statusKey,
    this.owner = const SelectionValue(),
    this.consultant = const SelectionValue(),
    this.contractor = const SelectionValue(),
    this.sector = const SelectionValue(),
    this.region = const SelectionValue(),
    this.projectType = const SelectionValue(),
    this.productionLine = const SelectionValue(),
    this.phaseDurationInDays,
    this.phaseProgressRatio,
    this.phaseStatus,
    this.supervisionConsultant = const SelectionValue(),
    this.supervisionEngineer = const SelectionValue(),
    this.civilEngineer = const SelectionValue(),
    this.architecturalEngineer = const SelectionValue(),
    this.electricalEngineer = const SelectionValue(),
    this.mechanicalEngineer = const SelectionValue(),
    this.surveyEngineer = const SelectionValue(),
    this.agriculturalEngineer = const SelectionValue(),
    this.generalEngineer = const SelectionValue(),
    this.projectManagementConsultant = const SelectionValue(),
    this.architecturalOfficer = const SelectionValue(),
    this.mechanicalOfficer = const SelectionValue(),
    this.electricalOfficer = const SelectionValue(),
    this.subcontractorAdoption = const SelectionValue(),
    this.receiveBusiness = const SelectionValue(),
    this.documentsAdoption = const SelectionValue(),
    this.executiveBoardsAdoption = const SelectionValue(),
    this.materialsAdoption = const SelectionValue(),
    this.materialsReceiveAndInspect = const SelectionValue(),
    this.informationRequest = const SelectionValue(),
    this.paymentCertificateAdoption = const SelectionValue(),
    this.siteWorkInstructions = const SelectionValue(),
    this.siteObservationReport = const SelectionValue(),
    this.nonConformanceReport = const SelectionValue(),
    this.tagNames = const [],
  });

  factory EditProjectFormData.empty() => const EditProjectFormData();

  factory EditProjectFormData.fromDto(ProjectEditDto dto) {
    return EditProjectFormData(
      title: dto.title,
      description: dto.description,
      projectCode: dto.projectCode ?? '',
      contractualBudget: _formatBudget(dto.contractualBudget),
      estimatedBudget: _formatBudget(dto.estimatedBudget),
      startDate: parseApiDate(dto.startDate),
      endDate: parseApiDate(dto.endDate),
      phaseJoinDate: parseApiDate(dto.currentStep?.startedAt),
      phaseKey: _phaseKeyFromStepType(dto.currentStep?.type),
      statusKey: _statusKeyFromCode(dto.status),
      owner: SelectionValue(id: dto.ownerId, label: dto.ownerName),
      consultant: SelectionValue(
        id: dto.consultantId,
        label: dto.consultantName,
      ),
      contractor: SelectionValue(
        id: dto.contractorId,
        label: dto.contractorName,
      ),
      sector: SelectionValue(id: dto.brandId, label: dto.brandName),
      region: SelectionValue(id: dto.productId, label: dto.productName),
      projectType: SelectionValue(id: dto.sizeMLId, label: dto.sizeMLName),
      productionLine: SelectionValue(
        id: dto.productionLineId,
        label: dto.productionLineName,
      ),
      phaseDurationInDays: dto.currentStep?.durationInDays,
      phaseProgressRatio: dto.currentStep?.progressRatio,
      phaseStatus: dto.currentStep?.status,
      supervisionConsultant: SelectionValue(
        id: dto.supervisionConsultantId,
        label: dto.supervisionConsultantName,
      ),
      supervisionEngineer: SelectionValue(
        id: dto.supervisionEngineerId,
        label: dto.supervisionEngineerName,
      ),
      civilEngineer: SelectionValue(
        id: dto.civilEngineerId,
        label: dto.civilEngineerName,
      ),
      architecturalEngineer: SelectionValue(
        id: dto.architecturalEngineerId,
        label: dto.architecturalEngineerName,
      ),
      electricalEngineer: SelectionValue(
        id: dto.electricalEngineerId,
        label: dto.electricalEngineerName,
      ),
      mechanicalEngineer: SelectionValue(
        id: dto.mechanicalEngineerId,
        label: dto.mechanicalEngineerName,
      ),
      surveyEngineer: SelectionValue(
        id: dto.surveyEngineerId,
        label: dto.surveyEngineerName,
      ),
      agriculturalEngineer: SelectionValue(
        id: dto.agriculturalEngineerId,
        label: dto.agriculturalEngineerName,
      ),
      generalEngineer: SelectionValue(
        id: dto.generalEngineerId,
        label: dto.generalEngineerName,
      ),
      projectManagementConsultant: SelectionValue(
        id: dto.projectManagementConsultantId,
        label: dto.projectManagementConsultantName,
      ),
      architecturalOfficer: SelectionValue(
        id: dto.architecturalOfficerId,
        label: dto.architecturalOfficerName,
      ),
      mechanicalOfficer: SelectionValue(
        id: dto.mechanicalOfficerId,
        label: dto.mechanicalOfficerName,
      ),
      electricalOfficer: SelectionValue(
        id: dto.electricalOfficerId,
        label: dto.electricalOfficerName,
      ),
      subcontractorAdoption: SelectionValue(
        id: dto.subcontractorAdoptionId,
        label: dto.subcontractorAdoptionName,
      ),
      receiveBusiness: SelectionValue(
        id: dto.receiveBusinessId,
        label: dto.receiveBusinessName,
      ),
      documentsAdoption: SelectionValue(
        id: dto.documentsAdoptionId,
        label: dto.documentsAdoptionName,
      ),
      executiveBoardsAdoption: SelectionValue(
        id: dto.executiveBoardsAdoptionId,
        label: dto.executiveBoardsAdoptionName,
      ),
      materialsAdoption: SelectionValue(
        id: dto.materialsAdoptionId,
        label: dto.materialsAdoptionName,
      ),
      materialsReceiveAndInspect: SelectionValue(
        id: dto.materialsReceiveAndInspectId,
        label: dto.materialsReceiveAndInspectName,
      ),
      informationRequest: SelectionValue(
        id: dto.informationRequestId,
        label: dto.informationRequestName,
      ),
      paymentCertificateAdoption: SelectionValue(
        id: dto.paymentCertificateAdoptionId,
        label: dto.paymentCertificateAdoptionName,
      ),
      siteWorkInstructions: SelectionValue(
        id: dto.siteWorkInstructionsId,
        label: dto.siteWorkInstructionsName,
      ),
      siteObservationReport: SelectionValue(
        id: dto.siteObservationReportId,
        label: dto.siteObservationReportName,
      ),
      nonConformanceReport: SelectionValue(
        id: dto.nonConformanceReportId,
        label: dto.nonConformanceReportName,
      ),
      tagNames: dto.tagNames,
    );
  }

  EditProjectFormData copyWith({
    String? title,
    String? description,
    String? projectCode,
    String? contractualBudget,
    String? estimatedBudget,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? phaseJoinDate,
    String? phaseKey,
    String? statusKey,
    SelectionValue? owner,
    SelectionValue? consultant,
    SelectionValue? contractor,
    SelectionValue? sector,
    SelectionValue? region,
    SelectionValue? projectType,
    SelectionValue? productionLine,
    SelectionValue? supervisionConsultant,
    SelectionValue? supervisionEngineer,
    SelectionValue? civilEngineer,
    SelectionValue? architecturalEngineer,
    SelectionValue? electricalEngineer,
    SelectionValue? mechanicalEngineer,
    SelectionValue? surveyEngineer,
    SelectionValue? agriculturalEngineer,
    SelectionValue? generalEngineer,
    SelectionValue? projectManagementConsultant,
    SelectionValue? architecturalOfficer,
    SelectionValue? mechanicalOfficer,
    SelectionValue? electricalOfficer,
    SelectionValue? subcontractorAdoption,
    SelectionValue? receiveBusiness,
    SelectionValue? documentsAdoption,
    SelectionValue? executiveBoardsAdoption,
    SelectionValue? materialsAdoption,
    SelectionValue? materialsReceiveAndInspect,
    SelectionValue? informationRequest,
    SelectionValue? paymentCertificateAdoption,
    SelectionValue? siteWorkInstructions,
    SelectionValue? siteObservationReport,
    SelectionValue? nonConformanceReport,
    List<String>? tagNames,
    int? phaseDurationInDays,
    dynamic phaseProgressRatio,
    dynamic phaseStatus,
  }) {
    return EditProjectFormData(
      title: title ?? this.title,
      description: description ?? this.description,
      projectCode: projectCode ?? this.projectCode,
      contractualBudget: contractualBudget ?? this.contractualBudget,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      phaseJoinDate: phaseJoinDate ?? this.phaseJoinDate,
      phaseKey: phaseKey ?? this.phaseKey,
      statusKey: statusKey ?? this.statusKey,
      owner: owner ?? this.owner,
      consultant: consultant ?? this.consultant,
      contractor: contractor ?? this.contractor,
      sector: sector ?? this.sector,
      region: region ?? this.region,
      projectType: projectType ?? this.projectType,
      productionLine: productionLine ?? this.productionLine,
      supervisionConsultant:
          supervisionConsultant ?? this.supervisionConsultant,
      supervisionEngineer: supervisionEngineer ?? this.supervisionEngineer,
      civilEngineer: civilEngineer ?? this.civilEngineer,
      architecturalEngineer:
          architecturalEngineer ?? this.architecturalEngineer,
      electricalEngineer: electricalEngineer ?? this.electricalEngineer,
      mechanicalEngineer: mechanicalEngineer ?? this.mechanicalEngineer,
      surveyEngineer: surveyEngineer ?? this.surveyEngineer,
      agriculturalEngineer: agriculturalEngineer ?? this.agriculturalEngineer,
      generalEngineer: generalEngineer ?? this.generalEngineer,
      projectManagementConsultant:
          projectManagementConsultant ?? this.projectManagementConsultant,
      architecturalOfficer: architecturalOfficer ?? this.architecturalOfficer,
      mechanicalOfficer: mechanicalOfficer ?? this.mechanicalOfficer,
      electricalOfficer: electricalOfficer ?? this.electricalOfficer,
      subcontractorAdoption:
          subcontractorAdoption ?? this.subcontractorAdoption,
      receiveBusiness: receiveBusiness ?? this.receiveBusiness,
      documentsAdoption: documentsAdoption ?? this.documentsAdoption,
      executiveBoardsAdoption:
          executiveBoardsAdoption ?? this.executiveBoardsAdoption,
      materialsAdoption: materialsAdoption ?? this.materialsAdoption,
      materialsReceiveAndInspect:
          materialsReceiveAndInspect ?? this.materialsReceiveAndInspect,
      informationRequest: informationRequest ?? this.informationRequest,
      paymentCertificateAdoption:
          paymentCertificateAdoption ?? this.paymentCertificateAdoption,
      siteWorkInstructions: siteWorkInstructions ?? this.siteWorkInstructions,
      siteObservationReport:
          siteObservationReport ?? this.siteObservationReport,
      nonConformanceReport:
          nonConformanceReport ?? this.nonConformanceReport,
      tagNames: tagNames ?? this.tagNames,
      phaseDurationInDays: phaseDurationInDays ?? this.phaseDurationInDays,
      phaseProgressRatio: phaseProgressRatio ?? this.phaseProgressRatio,
      phaseStatus: phaseStatus ?? this.phaseStatus,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        projectCode,
        contractualBudget,
        estimatedBudget,
        startDate,
        endDate,
        phaseJoinDate,
        phaseKey,
        statusKey,
        owner,
        consultant,
        contractor,
        sector,
        region,
        projectType,
        productionLine,
        phaseDurationInDays,
        phaseProgressRatio,
        phaseStatus,
        supervisionConsultant,
        supervisionEngineer,
        civilEngineer,
        architecturalEngineer,
        electricalEngineer,
        mechanicalEngineer,
        surveyEngineer,
        agriculturalEngineer,
        generalEngineer,
        projectManagementConsultant,
        architecturalOfficer,
        mechanicalOfficer,
        electricalOfficer,
        subcontractorAdoption,
        receiveBusiness,
        documentsAdoption,
        executiveBoardsAdoption,
        materialsAdoption,
        materialsReceiveAndInspect,
        informationRequest,
        paymentCertificateAdoption,
        siteWorkInstructions,
        siteObservationReport,
        nonConformanceReport,
        tagNames,
      ];
}

sealed class EditProjectState extends Equatable {
  const EditProjectState();

  @override
  List<Object?> get props => [];
}

class EditProjectInitial extends EditProjectState {}

class EditProjectLoading extends EditProjectState {}

class EditProjectError extends EditProjectState {
  final String message;

  const EditProjectError(this.message);

  @override
  List<Object?> get props => [message];
}

class EditProjectLoaded extends EditProjectState {
  final String projectId;
  final EditProjectFormData form;
  final bool isSubmitting;
  final String? submitError;

  const EditProjectLoaded({
    required this.projectId,
    required this.form,
    this.isSubmitting = false,
    this.submitError,
  });

  bool get isCreateMode => projectId.isEmpty;

  EditProjectLoaded copyWith({
    EditProjectFormData? form,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return EditProjectLoaded(
      projectId: projectId,
      form: form ?? this.form,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }

  @override
  List<Object?> get props => [projectId, form, isSubmitting, submitError];
}

String _formatBudget(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(2);
}

String? _phaseKeyFromStepType(int? type) {
  if (type == null) return null;
  if (type >= 0 && type < projectPhaseOptions.length) {
    return projectPhaseOptions[type];
  }
  return null;
}

String? _statusKeyFromCode(int code) {
  if (code >= 0 && code < projectStatusOptions.length) {
    return projectStatusOptions[code];
  }
  return null;
}
