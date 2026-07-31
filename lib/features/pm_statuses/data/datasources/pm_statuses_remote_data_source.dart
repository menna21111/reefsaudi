import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/pm_status.dart';

abstract class PmStatusesRemoteDataSource {
  Future<PmStatusListResult> getPmStatuses({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createPmStatus(PmStatusWriteRequest request);

  Future<void> updatePmStatus({
    required String id,
    required PmStatusWriteRequest request,
  });

  Future<void> deletePmStatus(String id);
}

class PmStatusesRemoteDataSourceImpl implements PmStatusesRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<PmStatusListResult> getPmStatuses({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.pmStatusListDx,
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
            .map(PmStatusDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <PmStatus>[];

    return PmStatusListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createPmStatus(PmStatusWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.pmStatusCreate,
      data: FormData.fromMap({
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> updatePmStatus({
    required String id,
    required PmStatusWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.pmStatusUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deletePmStatus(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.pmStatusDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class PmStatusDto extends PmStatus {
  const PmStatusDto({
    required super.id,
    required super.title,
    required super.description,
  });

  factory PmStatusDto.fromJson(Map<String, dynamic> json) {
    return PmStatusDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

extension PmStatusWriteRequestJson on PmStatusWriteRequest {
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
