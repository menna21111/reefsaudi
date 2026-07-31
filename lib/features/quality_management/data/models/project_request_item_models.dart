import 'project_request_detail_models.dart';

class ProjectRequestItem {
  const ProjectRequestItem({
    required this.id,
    required this.serialNumber,
    required this.reviewNumber,
    required this.requestDate,
    required this.projectId,
    required this.projectName,
    required this.statusId,
    required this.requestType,
    required this.requestTypeName,
    required this.specialization,
    required this.currentTask,
    required this.responsible,
    required this.contractor,
    required this.requestNote,
  });

  final String id;
  final String serialNumber;
  final String reviewNumber;
  final DateTime? requestDate;
  final String projectId;
  final String projectName;
  final int statusId;
  final int requestType;
  final String requestTypeName;
  final int specialization;
  final String? currentTask;
  final String? responsible;
  final String? contractor;
  final String? requestNote;

  factory ProjectRequestItem.fromJson(Map<String, dynamic> json) {
    return ProjectRequestItem(
      id: json['id']?.toString() ?? '',
      serialNumber: json['serialNumber']?.toString() ?? '',
      reviewNumber: json['reviewNumber']?.toString() ?? '',
      requestDate: _parseDate(json['requestDate']),
      projectId: json['projectId']?.toString() ?? '',
      projectName: json['projectName']?.toString() ?? '',
      statusId: _toInt(json['statusId']),
      requestType: _toInt(json['requestType']),
      requestTypeName: json['requestTypeName']?.toString() ?? '',
      specialization: _toInt(json['specialization']),
      currentTask: ProjectRequestCurrentTask.tryParse(json['currentTask'])
          ?.displayName,
      responsible: json['responsible']?.toString(),
      contractor: json['contractor']?.toString(),
      requestNote: json['requestNote']?.toString(),
    );
  }

  /// Create endpoint may return either a full object or only the new request id.
  factory ProjectRequestItem.fromCreateResponse(
    dynamic body, {
    required int serialNumber,
    required int reviewNumber,
    required DateTime requestDate,
    required String projectId,
    required int requestType,
    required int specialization,
    String? description,
  }) {
    if (body is Map<String, dynamic>) {
      return ProjectRequestItem.fromJson(body);
    }

    final id = _parseCreatedRequestId(body);
    if (id == null || id.isEmpty) {
      throw const FormatException('Unexpected create request response');
    }

    return ProjectRequestItem(
      id: id,
      serialNumber: '$serialNumber',
      reviewNumber: '$reviewNumber',
      requestDate: requestDate,
      projectId: projectId,
      projectName: '',
      statusId: 1,
      requestType: requestType,
      requestTypeName: '',
      specialization: specialization,
      currentTask: null,
      responsible: null,
      contractor: null,
      requestNote: description,
    );
  }
}

class ProjectRequestListResponse {
  const ProjectRequestListResponse({
    required this.data,
    required this.totalCount,
    required this.groupCount,
  });

  final List<ProjectRequestItem> data;
  final int totalCount;
  final int groupCount;

  factory ProjectRequestListResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return ProjectRequestListResponse(
      data: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(ProjectRequestItem.fromJson)
              .toList()
          : const [],
      totalCount: _toInt(json['totalCount']),
      groupCount: _toInt(json['groupCount']),
    );
  }
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

String? _parseCreatedRequestId(dynamic body) {
  if (body is String) {
    final trimmed = body.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  if (body is Map<String, dynamic>) {
    final id = body['id'] ?? body['data'];
    if (id == null) return null;
    final trimmed = id.toString().trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  return null;
}
