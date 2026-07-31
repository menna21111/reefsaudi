import '../../../../core/utils/app_string.dart';

class SupervisionConsultantRequestDetail {
  const SupervisionConsultantRequestDetail({
    this.description,
    this.correctiveAction,
    this.consultantNotesOnTheCorrectiveAction,
    this.consultantNotesForReceiptOfWorks,
    this.requestType,
    this.supervisionProcedures = const [],
  });

  final String? description;
  final String? correctiveAction;
  final String? consultantNotesOnTheCorrectiveAction;
  final String? consultantNotesForReceiptOfWorks;
  final String? requestType;
  final List<SupervisionProcedureItem> supervisionProcedures;

  factory SupervisionConsultantRequestDetail.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawProcedures = json['supervisionProcedures'];
    return SupervisionConsultantRequestDetail(
      description: json['description']?.toString(),
      correctiveAction: json['correctiveAction']?.toString(),
      consultantNotesOnTheCorrectiveAction:
          json['consultantNotesOnTheCorrectiveAction']?.toString(),
      consultantNotesForReceiptOfWorks:
          json['consultantNotesForReceiptOfWorks']?.toString(),
      requestType: json['requestType']?.toString(),
      supervisionProcedures: rawProcedures is List
          ? rawProcedures
              .whereType<Map<String, dynamic>>()
              .map(SupervisionProcedureItem.fromJson)
              .toList()
          : const [],
    );
  }
}

class SupervisionProcedureItem {
  const SupervisionProcedureItem({
    this.title,
    this.description,
  });

  final String? title;
  final String? description;

  factory SupervisionProcedureItem.fromJson(Map<String, dynamic> json) {
    return SupervisionProcedureItem(
      title: json['title']?.toString(),
      description: json['description']?.toString(),
    );
  }
}

class ProjectRequestCurrentTask {
  const ProjectRequestCurrentTask({
    this.id,
    this.title,
    this.description,
    this.status,
    this.firstName,
    this.lastName,
    this.email,
    this.assignedToId,
    this.assignedTo,
    this.isApprovalIdAction,
    this.approvalActionId,
    this.attachmentPath,
    this.attachmentName,
  });

  final String? id;
  final String? title;
  final String? description;
  final int? status;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? assignedToId;
  final String? assignedTo;
  final bool? isApprovalIdAction;
  final int? approvalActionId;
  final String? attachmentPath;
  final String? attachmentName;

  /// A–D rating mode when backend sets approval action id / flag.
  bool get usesApprovalRating =>
      isApprovalIdAction == true || approvalActionId != null;

  bool get hasAttachment =>
      attachmentPath != null && attachmentPath!.trim().isNotEmpty;

  String get displayAttachmentName {
    if (attachmentName != null && attachmentName!.trim().isNotEmpty) {
      return attachmentName!.trim();
    }
    return _fileNameFromPath(attachmentPath) ?? '';
  }

  bool get isEmpty =>
      !_hasText(title) &&
      !_hasText(description) &&
      !_hasText(assignedTo) &&
      !_hasText(firstName) &&
      !_hasText(email) &&
      status == null;

  String get displayName {
    if (_hasText(title)) return title!.trim();
    if (_hasText(assignedTo)) return assignedTo!.trim();
    if (_hasText(firstName)) return firstName!.trim();
    return '';
  }

  factory ProjectRequestCurrentTask.fromJson(Map<String, dynamic> json) {
    final attachment = _parseAttachmentRef(
      json['attachment'] ?? json['taskAttachment'] ?? json['attachmentRef'],
    );
    return ProjectRequestCurrentTask(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      status: json['status'] == null ? null : _toInt(json['status']),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      email: json['email']?.toString(),
      assignedToId:
          json['assignedToId']?.toString() ?? json['assignedTold']?.toString(),
      assignedTo: json['assignedTo']?.toString(),
      isApprovalIdAction: _toBool(json['isApprovalIdAction']),
      approvalActionId: json['approvalActionId'] == null
          ? null
          : _toInt(json['approvalActionId']),
      attachmentPath:
          attachment?.path ??
          json['attachmentPath']?.toString() ??
          json['taskAttachmentPath']?.toString(),
      attachmentName:
          attachment?.name ??
          json['attachmentName']?.toString() ??
          json['taskAttachmentName']?.toString(),
    );
  }

  static ProjectRequestCurrentTask? tryParse(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      return ProjectRequestCurrentTask.fromJson(value);
    }
    if (value is Map) {
      return ProjectRequestCurrentTask.fromJson(
        value.map((key, item) => MapEntry(key.toString(), item)),
      );
    }
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return ProjectRequestCurrentTask(title: text);
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;
}

class ReceiveBusinessDetail {
  const ReceiveBusinessDetail({
    this.buildingStatement,
    this.buildingComments,
    this.floorStatement,
    this.floorComments,
    this.approvedPlatesStatement,
    this.approvedPlatesComments,
    this.requiredExaminationDateStatement,
    this.requiredExaminationDateComments,
    this.workToBeExaminedStatement,
    this.workToBeExaminedComments,
    this.responsibleEngineer,
    this.responsibleDirector,
  });

  final String? buildingStatement;
  final String? buildingComments;
  final String? floorStatement;
  final String? floorComments;
  final String? approvedPlatesStatement;
  final String? approvedPlatesComments;
  final DateTime? requiredExaminationDateStatement;
  final String? requiredExaminationDateComments;
  final String? workToBeExaminedStatement;
  final String? workToBeExaminedComments;
  final String? responsibleEngineer;
  final String? responsibleDirector;

  factory ReceiveBusinessDetail.fromJson(Map<String, dynamic> json) {
    return ReceiveBusinessDetail(
      buildingStatement: json['buildingStatement']?.toString(),
      buildingComments: json['buildingComments']?.toString(),
      floorStatement: json['floorStatement']?.toString(),
      floorComments: json['floorComments']?.toString(),
      approvedPlatesStatement: json['approvedPlatesStatement']?.toString(),
      approvedPlatesComments: json['approvedPlatesComments']?.toString(),
      requiredExaminationDateStatement: _parseDate(
        json['requiredExaminationDateStatement'],
      ),
      requiredExaminationDateComments:
          json['requiredExaminationDateComments']?.toString(),
      workToBeExaminedStatement: json['workToBeExaminedStatement']?.toString(),
      workToBeExaminedComments: json['workToBeExaminedComments']?.toString(),
      responsibleEngineer: json['responsibleEngineer']?.toString(),
      responsibleDirector: json['responsibleDirector']?.toString(),
    );
  }
}

class DocumentsAdoptionDetailItem {
  const DocumentsAdoptionDetailItem({
    this.documentDescription,
    this.documentReviewNumber,
    this.numberOfCopies,
    this.recordType,
    this.attachmentPath,
    this.attachmentName,
  });

  final String? documentDescription;
  final String? documentReviewNumber;
  final String? numberOfCopies;
  final String? recordType;
  final String? attachmentPath;
  final String? attachmentName;

  bool get hasAttachment =>
      attachmentPath != null && attachmentPath!.trim().isNotEmpty;

  String get displayAttachmentName {
    if (attachmentName != null && attachmentName!.trim().isNotEmpty) {
      return attachmentName!.trim();
    }
    return _fileNameFromPath(attachmentPath) ?? '';
  }

  factory DocumentsAdoptionDetailItem.fromJson(Map<String, dynamic> json) {
    final attachment = _parseAttachmentRef(json['attachment']);
    return DocumentsAdoptionDetailItem(
      documentDescription: json['documentDescription']?.toString(),
      documentReviewNumber: json['documentReviewNumber']?.toString(),
      numberOfCopies: json['numberOfCopies']?.toString(),
      recordType: json['recordType']?.toString(),
      attachmentPath: attachment?.path,
      attachmentName: attachment?.name,
    );
  }
}

class MaterialsReceiveAndInspectDetail {
  const MaterialsReceiveAndInspectDetail({
    this.approvalApplicationNumber,
    this.accreditationDate,
    this.factoryName,
    this.requiredExaminationDate,
    this.materialDescription,
    this.attachmentsStatement,
    this.responsibleEngineerName,
    this.responsibleDirectorName,
    this.approvalApplicationNumberAttachmentPath,
    this.approvalApplicationNumberAttachmentName,
    this.factoryNameAttachmentPath,
    this.factoryNameAttachmentName,
    this.attachmentsStatementAttachmentPath,
    this.attachmentsStatementAttachmentName,
  });

  final String? approvalApplicationNumber;
  final DateTime? accreditationDate;
  final String? factoryName;
  final DateTime? requiredExaminationDate;
  final String? materialDescription;
  final String? attachmentsStatement;
  final String? responsibleEngineerName;
  final String? responsibleDirectorName;
  final String? approvalApplicationNumberAttachmentPath;
  final String? approvalApplicationNumberAttachmentName;
  final String? factoryNameAttachmentPath;
  final String? factoryNameAttachmentName;
  final String? attachmentsStatementAttachmentPath;
  final String? attachmentsStatementAttachmentName;

  factory MaterialsReceiveAndInspectDetail.fromJson(Map<String, dynamic> json) {
    final approvalAttachment =
        _parseAttachmentRef(json['approvalApplicationNumberAttachment']);
    final factoryAttachment = _parseAttachmentRef(json['factoryNameAttachment']);
    final statementAttachment =
        _parseAttachmentRef(json['attachmentsStatementAttachment']);

    return MaterialsReceiveAndInspectDetail(
      approvalApplicationNumber:
          json['approvalApplicationNumber']?.toString(),
      accreditationDate: _parseDate(json['accreditationDate']),
      factoryName: json['factoryName']?.toString(),
      requiredExaminationDate: _parseDate(json['requiredExaminationDate']),
      materialDescription: json['materialDescription']?.toString(),
      attachmentsStatement: json['attachmentsStatement']?.toString(),
      responsibleEngineerName: json['responsibleEngineerName']?.toString(),
      responsibleDirectorName: json['responsibleDirectorName']?.toString(),
      approvalApplicationNumberAttachmentPath: approvalAttachment?.path,
      approvalApplicationNumberAttachmentName: approvalAttachment?.name,
      factoryNameAttachmentPath: factoryAttachment?.path,
      factoryNameAttachmentName: factoryAttachment?.name,
      attachmentsStatementAttachmentPath: statementAttachment?.path,
      attachmentsStatementAttachmentName: statementAttachment?.name,
    );
  }
}

class _AttachmentRef {
  const _AttachmentRef({this.path, this.name});

  final String? path;
  final String? name;
}

_AttachmentRef? _parseAttachmentRef(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return _AttachmentRef(path: trimmed, name: _fileNameFromPath(trimmed));
  }
  if (value is Map) {
    final map = value.map((key, item) => MapEntry(key.toString(), item));
    final path = map['attachmentPath']?.toString() ??
        map['path']?.toString() ??
        map['url']?.toString() ??
        map['filePath']?.toString();
    final name = map['name']?.toString() ??
        map['fileName']?.toString() ??
        _fileNameFromPath(path);
    if ((path == null || path.trim().isEmpty) &&
        (name == null || name.trim().isEmpty)) {
      return null;
    }
    return _AttachmentRef(
      path: path?.trim().isEmpty == true ? null : path?.trim(),
      name: name?.trim().isEmpty == true ? null : name?.trim(),
    );
  }
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return _AttachmentRef(path: text, name: _fileNameFromPath(text));
}

String? _fileNameFromPath(String? path) {
  if (path == null || path.trim().isEmpty) return null;
  final normalized = path.replaceAll('\\', '/');
  final name = normalized.split('/').last.trim();
  return name.isEmpty ? path : name;
}

class ProjectRequestDetail {
  const ProjectRequestDetail({
    required this.id,
    required this.serialNumber,
    required this.reviewNumber,
    required this.requestDate,
    required this.projectId,
    required this.projectName,
    required this.specialization,
    required this.statusId,
    required this.requestType,
    required this.requestTypeName,
    required this.contractorName,
    this.approvalId,
    this.ownerNotes,
    this.supervisionConsultantNotes,
    this.requestUrlOnDrive,
    this.currentTask,
    this.supervisionConsultantRequest,
    this.receiveBusiness,
    this.documentsAdoption = const [],
    this.materialsReceiveAndInspect,
  });

  final String id;
  final String serialNumber;
  final String reviewNumber;
  final DateTime? requestDate;
  final String projectId;
  final String projectName;
  final int specialization;
  final int statusId;
  final int requestType;
  final String requestTypeName;
  final String? contractorName;
  final String? approvalId;
  final String? ownerNotes;
  final String? supervisionConsultantNotes;
  final String? requestUrlOnDrive;
  final ProjectRequestCurrentTask? currentTask;
  final SupervisionConsultantRequestDetail? supervisionConsultantRequest;
  final ReceiveBusinessDetail? receiveBusiness;
  final List<DocumentsAdoptionDetailItem> documentsAdoption;
  final MaterialsReceiveAndInspectDetail? materialsReceiveAndInspect;

  String? get primaryDescription =>
      _firstNonEmpty([
        supervisionConsultantRequest?.description,
        supervisionConsultantRequest?.correctiveAction,
      ]);

  factory ProjectRequestDetail.fromJson(Map<String, dynamic> json) {
    final supervisionRaw = json['supervisionConsultantRequest'];
    final receiveRaw = json['receiveBusiness'];
    final materialsRaw = json['materialsReceiveAndInspect'];
    final documentsRaw =
        json['documentsAdoption'] ?? json['DocumentsAdoption'];

    return ProjectRequestDetail(
      id: json['id']?.toString() ?? '',
      serialNumber: json['serialNumber']?.toString() ?? '',
      reviewNumber: json['reviewNumber']?.toString() ?? '',
      requestDate: _parseDate(json['requestDate']),
      projectId: json['projectId']?.toString() ?? '',
      projectName: json['projectName']?.toString() ?? '',
      specialization: _toInt(json['specialization']),
      statusId: _toInt(json['statusId']),
      requestType: _toInt(json['requestType']),
      requestTypeName: json['requestTypeName']?.toString() ?? '',
      contractorName: json['contractorName']?.toString(),
      approvalId: json['approvalID']?.toString() ?? json['approvalId']?.toString(),
      ownerNotes: json['ownerNotes']?.toString(),
      supervisionConsultantNotes:
          json['supervisionConsultantNotes']?.toString(),
      requestUrlOnDrive: json['requestUrlOnDrive']?.toString(),
      currentTask: ProjectRequestCurrentTask.tryParse(json['currentTask']),
      supervisionConsultantRequest: supervisionRaw is Map<String, dynamic>
          ? SupervisionConsultantRequestDetail.fromJson(supervisionRaw)
          : null,
      receiveBusiness: receiveRaw is Map<String, dynamic>
          ? ReceiveBusinessDetail.fromJson(receiveRaw)
          : null,
      documentsAdoption: documentsRaw is List
          ? documentsRaw
              .whereType<Map<String, dynamic>>()
              .map(DocumentsAdoptionDetailItem.fromJson)
              .toList()
          : const [],
      materialsReceiveAndInspect: materialsRaw is Map<String, dynamic>
          ? MaterialsReceiveAndInspectDetail.fromJson(materialsRaw)
          : null,
    );
  }
}

String? _firstNonEmpty(List<String?> values) {
  for (final value in values) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isNotEmpty) return trimmed;
  }
  return null;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

abstract final class SpecializationLabels {
  static String labelKeyFor(int value) {
    return switch (value) {
      1 => AppString.specializationGeneral,
      2 => AppString.civilEngineer,
      3 => AppString.architecturalEngineer,
      4 => AppString.electricalEngineer,
      5 => AppString.mechanicalEngineer,
      6 => AppString.agriculturalEngineer,
      7 => AppString.specializationGeneral,
      _ => AppString.specializationGeneral,
    };
  }
}
