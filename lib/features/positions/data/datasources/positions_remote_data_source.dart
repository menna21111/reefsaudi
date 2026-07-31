import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/position.dart';

abstract class PositionsRemoteDataSource {
  Future<PositionListResult> getPositions({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createPosition(PositionWriteRequest request);

  Future<void> updatePosition({
    required String id,
    required PositionWriteRequest request,
  });

  Future<void> deletePosition(String id);
}

class PositionsRemoteDataSourceImpl implements PositionsRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<PositionListResult> getPositions({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.designationListDx,
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
            .map(PositionDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <Position>[];

    return PositionListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createPosition(PositionWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.designationCreate,
      data: FormData.fromMap({
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> updatePosition({
    required String id,
    required PositionWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.designationUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deletePosition(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.designationDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class PositionDto extends Position {
  const PositionDto({
    required super.id,
    required super.title,
    required super.description,
  });

  factory PositionDto.fromJson(Map<String, dynamic> json) {
    return PositionDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

extension PositionWriteRequestJson on PositionWriteRequest {
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
