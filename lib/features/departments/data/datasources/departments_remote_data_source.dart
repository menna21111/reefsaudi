import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/department.dart';

abstract class DepartmentsRemoteDataSource {
  Future<DepartmentListResult> getDepartments({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createDepartment(DepartmentWriteRequest request);

  Future<void> updateDepartment({
    required String id,
    required DepartmentWriteRequest request,
  });

  Future<void> deleteDepartment(String id);
}

class DepartmentsRemoteDataSourceImpl implements DepartmentsRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<DepartmentListResult> getDepartments({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.departmentListDx,
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
            .map(DepartmentDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <Department>[];

    return DepartmentListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createDepartment(DepartmentWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.departmentCreate,
      data: FormData.fromMap({
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> updateDepartment({
    required String id,
    required DepartmentWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.departmentUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deleteDepartment(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.departmentDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class DepartmentDto extends Department {
  const DepartmentDto({
    required super.id,
    required super.title,
    required super.description,
  });

  factory DepartmentDto.fromJson(Map<String, dynamic> json) {
    return DepartmentDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

extension DepartmentWriteRequestJson on DepartmentWriteRequest {
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
