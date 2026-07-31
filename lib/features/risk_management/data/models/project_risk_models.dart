import 'dart:convert';

import 'package:dio/dio.dart';

import '../../presentation/constants/risk_enums.dart';

class ProjectRiskDto {
  const ProjectRiskDto({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
    this.ownerName,
    required this.approvedById,
    this.approvedByName,
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

  final String id;
  final String title;
  final String? description;
  final String ownerId;
  final String? ownerName;
  final String approvedById;
  final String? approvedByName;
  final String riskStatus;
  final String riskProbability;
  final String riskImpact;
  final String riskPriority;
  final String riskResponse;
  final String? riskDate;
  final String responsePlan;
  final String contingencyPlan;
  final String projectId;
  final String? projectTitle;
  final String? region;

  factory ProjectRiskDto.fromJson(Map<String, dynamic> json) {
    final project = json['project'];
    return ProjectRiskDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      ownerId: json['ownerId']?.toString() ?? '',
      ownerName: json['ownerName']?.toString(),
      approvedById: json['approvedById']?.toString() ?? '',
      approvedByName: json['approvedByName']?.toString(),
      riskStatus: RiskApiValueMapper.statusFromApi(json['riskStatus']),
      riskProbability:
          RiskApiValueMapper.probabilityFromApi(json['riskProbability']),
      riskImpact: RiskApiValueMapper.impactFromApi(json['riskImpact']),
      riskPriority: RiskApiValueMapper.priorityFromApi(json['riskPriority']),
      riskResponse: RiskApiValueMapper.responseFromApi(json['riskResponse']),
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
  const ProjectRiskListResponse({
    required this.data,
    required this.totalCount,
  });

  final List<ProjectRiskDto> data;
  final int totalCount;

  factory ProjectRiskListResponse.fromJson(Map<String, dynamic> json) {
    return ProjectRiskListResponse(
      data: parseProjectRisks(json['data']),
      totalCount: _toInt(json['totalCount']),
    );
  }
}

class AccountDxItemDto {
  const AccountDxItemDto({required this.id, required this.fullName});

  final String id;
  final String fullName;

  factory AccountDxItemDto.fromJson(Map<String, dynamic> json) {
    return AccountDxItemDto(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

class ProjectRiskWriteRequest {
  const ProjectRiskWriteRequest({
    required this.title,
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
    this.id,
    this.projectId,
  });

  final String? id;
  final String? projectId;
  final String title;
  final String? description;
  final String responsePlan;
  final String contingencyPlan;
  final DateTime riskDate;
  final String ownerId;
  final String approvedById;
  final String riskPriority;
  final String riskResponse;
  final String riskImpact;
  final String riskProbability;
  final String riskStatus;

  factory ProjectRiskWriteRequest.fromDto(ProjectRiskDto dto) {
    return ProjectRiskWriteRequest(
      id: dto.id,
      projectId: dto.projectId,
      title: dto.title,
      description: dto.description,
      responsePlan: dto.responsePlan,
      contingencyPlan: dto.contingencyPlan,
      riskDate: DateTime.tryParse(dto.riskDate ?? '') ?? DateTime.now(),
      ownerId: dto.ownerId,
      approvedById: dto.approvedById,
      riskPriority: dto.riskPriority,
      riskResponse: dto.riskResponse,
      riskImpact: dto.riskImpact,
      riskProbability: dto.riskProbability,
      riskStatus: dto.riskStatus,
    );
  }

  Map<String, dynamic> toApiValuesJson({String? projectId}) {
    final resolvedProjectId = projectId ?? this.projectId;
    final json = <String, dynamic>{
      'title': title,
      'description': description ?? '',
      'responsePlan': responsePlan,
      'contingencyPlan': contingencyPlan,
      'riskDate': formatProjectRiskDate(riskDate),
      'ownerId': ownerId,
      'approvedById': approvedById,
      'riskPriority': RiskApiValueMapper.priorityToApi(riskPriority),
      'riskResponse': RiskApiValueMapper.responseToApi(riskResponse),
      'riskImpact': RiskApiValueMapper.impactToApi(riskImpact),
      'riskProbability': RiskApiValueMapper.probabilityToApi(riskProbability),
      'riskStatus': RiskApiValueMapper.statusToApi(riskStatus),
    };
    if (resolvedProjectId != null && resolvedProjectId.isNotEmpty) {
      json['projectId'] = resolvedProjectId;
    }
    if (id != null && id!.isNotEmpty) json['id'] = id;
    return json;
  }

  FormData toFormData({String? projectId}) {
    return FormData.fromMap({
      'values': jsonEncode(toApiValuesJson(projectId: projectId)),
    });
  }

  FormData toUpdateFormData() {
    return FormData.fromMap({
      if (id != null && id!.isNotEmpty) 'key': id,
      'values': jsonEncode(toApiValuesJson()),
    });
  }

  @Deprecated('Use toApiValuesJson / toFormData for API calls')
  Map<String, dynamic> toJson() => toApiValuesJson();
}

/// Legacy int-based request kept for global risk management screen compatibility.
class CreateProjectRiskRequest {
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

  final String title;
  final String projectId;
  final String? description;
  final String responsePlan;
  final String contingencyPlan;
  final DateTime riskDate;
  final String ownerId;
  final String approvedById;
  final String riskPriority;
  final String riskResponse;
  final String riskImpact;
  final String riskProbability;
  final String riskStatus;

  Map<String, dynamic> toApiValuesJson() => {
        'title': title,
        'projectId': projectId,
        if (description != null && description!.isNotEmpty)
          'description': description,
        'responsePlan': responsePlan,
        'contingencyPlan': contingencyPlan,
        'riskDate': formatProjectRiskDate(riskDate),
        'ownerId': ownerId,
        'approvedById': approvedById,
        'riskPriority': RiskApiValueMapper.priorityToApi(riskPriority),
        'riskResponse': RiskApiValueMapper.responseToApi(riskResponse),
        'riskImpact': RiskApiValueMapper.impactToApi(riskImpact),
        'riskProbability': RiskApiValueMapper.probabilityToApi(riskProbability),
        'riskStatus': RiskApiValueMapper.statusToApi(riskStatus),
      };

  FormData toFormData() {
    return FormData.fromMap({
      'values': jsonEncode(toApiValuesJson()),
    });
  }

  @Deprecated('Use toApiValuesJson / toFormData for API calls')
  Map<String, dynamic> toJson() => toApiValuesJson();
}

String formatProjectRiskDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-${day}T00:00:00.000';
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
