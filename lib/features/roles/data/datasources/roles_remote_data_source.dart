import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/role.dart';

abstract class RolesRemoteDataSource {
  Future<RoleListResult> getRoles({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createRole(RoleWriteRequest request);

  Future<RoleDetails> getRoleDetails(String roleId);

  Future<void> updateRole(RoleUpdateRequest request);
}

class RolesRemoteDataSourceImpl implements RolesRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<RoleListResult> getRoles({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.roleListDx,
      query: DxListQuery.paged(
        skip: skip,
        take: take,
        searchText: searchText,
        searchFields: const ['name', 'id'],
      ),
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(RoleItemDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <RoleItem>[];

    return RoleListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createRole(RoleWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.roleCreate,
      data: FormData.fromMap({
        'values': jsonEncode({'name': request.name}),
      }),
    );
  }

  @override
  Future<RoleDetails> getRoleDetails(String roleId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.roleDetails,
      query: {'roleId': roleId},
    );
    final body = await _readMapResponse(response.data);
    return RoleDetailsDto.fromJson(body);
  }

  @override
  Future<void> updateRole(RoleUpdateRequest request) async {
    await DioHelper.putData(
      url: PmoEndpoints.roleUpdate,
      data: {
        'id': request.id,
        'name': request.name,
        'selectedPermissions': request.selectedPermissions,
      },
      legacyAuthQuery: false,
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class RoleItemDto extends RoleItem {
  const RoleItemDto({required super.id, required super.name});

  factory RoleItemDto.fromJson(Map<String, dynamic> json) {
    return RoleItemDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class RoleDetailsDto extends RoleDetails {
  const RoleDetailsDto({
    required super.id,
    required super.name,
    required super.permissionGroups,
  });

  factory RoleDetailsDto.fromJson(Map<String, dynamic> json) {
    final rawGroups = json['rolePermissions'];
    final groups = rawGroups is List
        ? rawGroups
            .whereType<Map<String, dynamic>>()
            .map(RolePermissionGroupDto.fromJson)
            .toList()
        : <RolePermissionGroup>[];

    return RoleDetailsDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      permissionGroups: groups,
    );
  }
}

class RolePermissionGroupDto extends RolePermissionGroup {
  const RolePermissionGroupDto({
    required super.groupName,
    required super.permissions,
  });

  factory RolePermissionGroupDto.fromJson(Map<String, dynamic> json) {
    final rawPermissions = json['permissions'];
    final permissions = rawPermissions is List
        ? rawPermissions
            .whereType<Map<String, dynamic>>()
            .map(RolePermissionDto.fromJson)
            .toList()
        : <RolePermission>[];

    return RolePermissionGroupDto(
      groupName: json['permissionsGroupName']?.toString() ?? '',
      permissions: permissions,
    );
  }
}

class RolePermissionDto extends RolePermission {
  const RolePermissionDto({
    required super.name,
    required super.displayName,
    required super.value,
  });

  factory RolePermissionDto.fromJson(Map<String, dynamic> json) {
    return RolePermissionDto(
      name: json['name']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      value: json['value'] == true,
    );
  }
}
