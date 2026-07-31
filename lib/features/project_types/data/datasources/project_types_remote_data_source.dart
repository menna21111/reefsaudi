import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/project_type.dart';

abstract class ProjectTypesRemoteDataSource {
  Future<ProjectTypeListResult> getProjectTypes({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createProjectType(ProjectTypeWriteRequest request);

  Future<void> updateProjectType({
    required String id,
    required ProjectTypeWriteRequest request,
  });

  Future<void> deleteProjectType(String id);
}

class ProjectTypesRemoteDataSourceImpl implements ProjectTypesRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<ProjectTypeListResult> getProjectTypes({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.sizeMlListDxApi,
      query: DxListQuery.paged(
        skip: skip,
        take: take,
        searchText: searchText,
      ),
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(ProjectTypeDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <ProjectType>[];

    return ProjectTypeListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createProjectType(ProjectTypeWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.sizeMlCreate,
      data: FormData.fromMap({
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> updateProjectType({
    required String id,
    required ProjectTypeWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.sizeMlUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deleteProjectType(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.sizeMlDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class ProjectTypeDto extends ProjectType {
  const ProjectTypeDto({
    required super.id,
    required super.title,
    required super.description,
  });

  factory ProjectTypeDto.fromJson(Map<String, dynamic> json) {
    return ProjectTypeDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

extension ProjectTypeWriteRequestJson on ProjectTypeWriteRequest {
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
