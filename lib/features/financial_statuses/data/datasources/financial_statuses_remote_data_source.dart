import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/financial_status.dart';

abstract class FinancialStatusesRemoteDataSource {
  Future<FinancialStatusListResult> getFinancialStatuses({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createFinancialStatus(FinancialStatusWriteRequest request);

  Future<void> updateFinancialStatus({
    required String id,
    required FinancialStatusWriteRequest request,
  });

  Future<void> deleteFinancialStatus(String id);
}

class FinancialStatusesRemoteDataSourceImpl
    implements FinancialStatusesRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  Map<String, dynamic> _writePayload(FinancialStatusWriteRequest request) {
    return {
      'title': request.title,
      'description': request.description,
      'isFinal': request.isFinal.toString(),
    };
  }

  @override
  Future<FinancialStatusListResult> getFinancialStatuses({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.financialStatusListDx,
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
            .map(FinancialStatusDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <FinancialStatusItem>[];

    return FinancialStatusListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createFinancialStatus(FinancialStatusWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.financialStatusCreate,
      data: FormData.fromMap(_writePayload(request)),
    );
  }

  @override
  Future<void> updateFinancialStatus({
    required String id,
    required FinancialStatusWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.financialStatusUpdate,
      data: FormData.fromMap({
        'key': id,
        ..._writePayload(request),
      }),
    );
  }

  @override
  Future<void> deleteFinancialStatus(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.financialStatusDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class FinancialStatusDto extends FinancialStatusItem {
  const FinancialStatusDto({
    required super.id,
    required super.title,
    required super.description,
    required super.isFinal,
  });

  factory FinancialStatusDto.fromJson(Map<String, dynamic> json) {
    return FinancialStatusDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isFinal: _toBool(json['isFinal']),
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
}
