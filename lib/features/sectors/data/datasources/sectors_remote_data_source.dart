import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/sector.dart';

abstract class SectorsRemoteDataSource {
  Future<SectorListResult> getSectors({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createSector(SectorWriteRequest request);

  Future<void> updateSector({
    required String id,
    required SectorWriteRequest request,
  });

  Future<void> deleteSector(String id);
}

class SectorsRemoteDataSourceImpl implements SectorsRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<SectorListResult> getSectors({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.brandListDx,
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
            .map(SectorDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <Sector>[];

    return SectorListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createSector(SectorWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.brandCreate,
      data: FormData.fromMap({
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> updateSector({
    required String id,
    required SectorWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.brandUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deleteSector(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.brandDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class SectorDto extends Sector {
  const SectorDto({
    required super.id,
    required super.title,
    required super.description,
  });

  factory SectorDto.fromJson(Map<String, dynamic> json) {
    return SectorDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

extension SectorWriteRequestJson on SectorWriteRequest {
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
