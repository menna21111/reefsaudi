import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/region.dart';

abstract class RegionsRemoteDataSource {
  Future<RegionListResult> getRegions({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createRegion(RegionWriteRequest request);

  Future<void> updateRegion({
    required String id,
    required RegionWriteRequest request,
  });

  Future<void> deleteRegion(String id);
}

class RegionsRemoteDataSourceImpl implements RegionsRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<RegionListResult> getRegions({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.productListDx,
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
            .map(RegionDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <Region>[];

    return RegionListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createRegion(RegionWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.productCreate,
      data: FormData.fromMap({
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> updateRegion({
    required String id,
    required RegionWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.productUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deleteRegion(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.productDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class RegionDto extends Region {
  const RegionDto({
    required super.id,
    required super.title,
    required super.description,
  });

  factory RegionDto.fromJson(Map<String, dynamic> json) {
    return RegionDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

extension RegionWriteRequestJson on RegionWriteRequest {
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
