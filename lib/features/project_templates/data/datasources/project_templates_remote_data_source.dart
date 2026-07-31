import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/project_template.dart';

abstract class ProjectTemplatesRemoteDataSource {
  Future<ProjectTemplateListResult> getProjectTemplates({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createProjectTemplate(ProjectTemplateWriteRequest request);

  Future<void> updateProjectTemplate({
    required String id,
    required ProjectTemplateWriteRequest request,
  });

  Future<void> deleteProjectTemplate(String id);

  Future<TemplateGanttData> getTemplateGantt(String templateId);

  Future<void> saveTemplateGantt({
    required String templateId,
    required TemplateGanttData data,
    required TemplateGanttAction action,
  });
}

class ProjectTemplatesRemoteDataSourceImpl
    implements ProjectTemplatesRemoteDataSource {
  @override
  Future<ProjectTemplateListResult> getProjectTemplates({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectTemplate,
      query: DxListQuery.paged(
        skip: skip,
        take: take,
        searchText: searchText,
        searchFields: const ['name'],
      ),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }

    final rawItems = body['data'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(ProjectTemplateDto.fromJson)
              .where((item) => item.id.isNotEmpty)
              .toList()
        : <ProjectTemplate>[];

    return ProjectTemplateListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createProjectTemplate(
    ProjectTemplateWriteRequest request,
  ) async {
    await DioHelper.postData(
      url: PmoEndpoints.projectTemplate,
      data: FormData.fromMap(request.toJson()),
    );
  }

  @override
  Future<void> updateProjectTemplate({
    required String id,
    required ProjectTemplateWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.projectTemplate,
      legacyAuthQuery: false,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deleteProjectTemplate(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.projectTemplate,
      data: FormData.fromMap({'key': id}),
    );
  }

  @override
  Future<TemplateGanttData> getTemplateGantt(String templateId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectTemplateGantt(templateId),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }

    final rawTasks = body['tasks'];
    final tasks = rawTasks is List
        ? rawTasks
              .whereType<Map>()
              .map((e) => TemplateGanttTaskDto.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .where((task) => task.id.isNotEmpty)
              .toList()
        : <TemplateGanttTask>[];
    tasks.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));

    final rawDependencies = body['dependancy'] ?? body['dependency'];
    final dependencies = rawDependencies is List
        ? rawDependencies
              .whereType<Map>()
              .map((e) {
                final json = Map<String, dynamic>.from(e);
                return TemplateGanttDependency(
                  id: json['id']?.toString(),
                  predecessorId: json['predecessorId']?.toString() ?? '',
                  successorId: json['successorId']?.toString() ?? '',
                  type: TemplateGanttTaskDto._toInt(json['type']),
                );
              })
              .where(
                (d) =>
                    d.predecessorId.isNotEmpty && d.successorId.isNotEmpty,
              )
              .toList()
        : <TemplateGanttDependency>[];

    List<Map<String, dynamic>> asMaps(dynamic raw) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return TemplateGanttData(
      tasks: tasks,
      dependencies: dependencies,
      resources: asMaps(body['resources']),
      resourceAssignments: asMaps(body['resourceAssignments']),
    );
  }

  @override
  Future<void> saveTemplateGantt({
    required String templateId,
    required TemplateGanttData data,
    required TemplateGanttAction action,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.projectTemplateGantt(templateId),
      legacyAuthQuery: false,
      query: {'action': action.apiValue},
      data: data.toApiJson(),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class TemplateGanttTaskDto extends TemplateGanttTask {
  const TemplateGanttTaskDto({
    required super.id,
    required super.title,
    required super.sortIndex,
    required super.assignToType,
    required super.isApprovalAction,
    super.raw,
  });

  factory TemplateGanttTaskDto.fromJson(Map<String, dynamic> json) {
    return TemplateGanttTaskDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      sortIndex: _toInt(json['sortIndex'] ?? json['taskOrder']),
      assignToType: _toInt(json['assignToType']),
      isApprovalAction: json['isApprovalIdAction'] == true,
      raw: Map<String, dynamic>.from(json),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ProjectTemplateDto extends ProjectTemplate {
  const ProjectTemplateDto({
    required super.id,
    required super.name,
    required super.requestType,
    required super.published,
  });

  factory ProjectTemplateDto.fromJson(Map<String, dynamic> json) {
    return ProjectTemplateDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      requestType: _toInt(json['requestType']),
      published: json['published'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
