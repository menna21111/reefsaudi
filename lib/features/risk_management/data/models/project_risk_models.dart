class ProjectRiskDto {
  final String id;
  final String title;
  final String? description;
  final String ownerId;
  final String approvedById;
  final int riskStatus;
  final int riskProbability;
  final int riskImpact;
  final int riskPriority;
  final int riskResponse;
  final String? riskDate;
  final String responsePlan;
  final String contingencyPlan;
  final String projectId;
  final String? projectTitle;
  final String? region;

  const ProjectRiskDto({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
    required this.approvedById,
    required this.riskStatus,
    required this.riskProbability,
    required this.riskImpact,
    required this.riskPriority,
    required this.riskResponse,
    this.riskDate,
    required this.responsePlan,
    required this.contingencyPlan,
    required this.projectId,
    this.projectTitle,
    this.region,
  });

  factory ProjectRiskDto.fromJson(Map<String, dynamic> json) {
    final project = json['project'];
    return ProjectRiskDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      ownerId: json['ownerId']?.toString() ?? '',
      approvedById: json['approvedById']?.toString() ?? '',
      riskStatus: _toInt(json['riskStatus']),
      riskProbability: _toInt(json['riskProbability']),
      riskImpact: _toInt(json['riskImpact']),
      riskPriority: _toInt(json['riskPriority']),
      riskResponse: _toInt(json['riskResponse']),
      riskDate: json['riskDate']?.toString(),
      responsePlan: json['responsePlan']?.toString() ?? '',
      contingencyPlan: json['contingencyPlan']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      projectTitle: project is Map<String, dynamic>
          ? project['title']?.toString()
          : null,
      region: json['region']?.toString(),
    );
  }
}

class ProjectRiskListResponse {
  final List<ProjectRiskDto> data;
  final int totalCount;

  const ProjectRiskListResponse({
    required this.data,
    required this.totalCount,
  });

  factory ProjectRiskListResponse.fromJson(Map<String, dynamic> json) {
    return ProjectRiskListResponse(
      data: parseProjectRisks(json['data']),
      totalCount: _toInt(json['totalCount']),
    );
  }
}

class AccountDxItemDto {
  final String id;
  final String fullName;

  const AccountDxItemDto({required this.id, required this.fullName});

  factory AccountDxItemDto.fromJson(Map<String, dynamic> json) {
    return AccountDxItemDto(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

class CreateProjectRiskRequest {
  final String title;
  final String projectId;
  final String? description;
  final String responsePlan;
  final String contingencyPlan;
  final DateTime riskDate;
  final String ownerId;
  final String approvedById;
  final int riskPriority;
  final int riskResponse;
  final int riskImpact;
  final int riskProbability;
  final int riskStatus;

  const CreateProjectRiskRequest({
    required this.title,
    required this.projectId,
    this.description,
    required this.responsePlan,
    required this.contingencyPlan,
    required this.riskDate,
    required this.ownerId,
    required this.approvedById,
    required this.riskPriority,
    required this.riskResponse,
    required this.riskImpact,
    required this.riskProbability,
    required this.riskStatus,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'projectId': projectId,
        if (description != null && description!.isNotEmpty)
          'description': description,
        'responsePlan': responsePlan,
        'contingencyPlan': contingencyPlan,
        'riskDate': riskDate.toUtc().toIso8601String(),
        'ownerId': ownerId,
        'approvedById': approvedById,
        'riskPriority': riskPriority,
        'riskResponse': riskResponse,
        'riskImpact': riskImpact,
        'riskProbability': riskProbability,
        'riskStatus': riskStatus,
      };
}

List<ProjectRiskDto> parseProjectRisks(dynamic raw) {
  if (raw is! List) return [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(ProjectRiskDto.fromJson)
      .toList();
}

List<AccountDxItemDto> parseAccountDxItems(dynamic raw) {
  if (raw is! List) return [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(AccountDxItemDto.fromJson)
      .toList();
}

int _toInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}
