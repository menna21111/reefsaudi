import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../domain/models/project_stage_assignment.dart';

abstract class ProjectStagesRemoteDataSource {
  Future<ProjectStageListResult> getProjectStages({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<List<ProjectStageOption>> getProjects();

  Future<List<ProjectStageOption>> getStepOptions();

  Future<void> createProjectStage(ProjectStageWriteRequest request);

  Future<void> updateProjectStage({
    required String id,
    required ProjectStageWriteRequest request,
  });

  Future<void> deleteProjectStage(String id);
}

class ProjectStagesRemoteDataSourceImpl implements ProjectStagesRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  Map<String, dynamic> _valuesJson(ProjectStageWriteRequest request) => {
        'projectId': request.projectId,
        'pStepId': request.pStepId,
        'assignedDate': request.assignedDate,
      };

  @override
  Future<ProjectStageListResult> getProjectStages({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStepListDx,
      query: DxListQuery.paged(
        skip: skip,
        take: take,
        searchText: searchText,
        searchFields: const ['projectTitle', 'pStepTitle', 'id'],
      ),
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(ProjectStageAssignmentDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <ProjectStageAssignment>[];

    return ProjectStageListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<List<ProjectStageOption>> getProjects() async {
    final response = await DioHelper.getData(url: PmoEndpoints.projectDxList);
    final body = await _readMapResponse(response.data);
    return parseProjectDxItems(body['data'])
        .map(
          (item) => ProjectStageOption(id: item.id, title: item.title),
        )
        .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
        .toList();
  }

  @override
  Future<List<ProjectStageOption>> getStepOptions() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.pStepsListDx,
      query: {'_': DateTime.now().millisecondsSinceEpoch},
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    if (rawItems is! List) return const [];

    return rawItems
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => ProjectStageOption(
            id: json['id']?.toString() ?? '',
            title: json['title']?.toString() ?? '',
          ),
        )
        .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
        .toList();
  }

  @override
  Future<void> createProjectStage(ProjectStageWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.projectStepCreate,
      data: FormData.fromMap({
        'values': jsonEncode(_valuesJson(request)),
      }),
    );
  }

  @override
  Future<void> updateProjectStage({
    required String id,
    required ProjectStageWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.projectStepUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode({
          'projectId': request.projectId,
          'pStepId': request.pStepId,
        }),
      }),
    );
  }

  @override
  Future<void> deleteProjectStage(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.projectStepDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class ProjectStageAssignmentDto extends ProjectStageAssignment {
  const ProjectStageAssignmentDto({
    required super.id,
    required super.projectId,
    required super.projectTitle,
    required super.pStepId,
    required super.pStepTitle,
    required super.assignedDate,
    super.isCompleted,
  });

  factory ProjectStageAssignmentDto.fromJson(Map<String, dynamic> json) {
    return ProjectStageAssignmentDto(
      id: json['id']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      projectTitle: json['projectTitle']?.toString() ?? '',
      pStepId: json['pStepId']?.toString() ?? '',
      pStepTitle: json['pStepTitle']?.toString() ?? '',
      assignedDate: json['assignedDate']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true,
    );
  }
}
