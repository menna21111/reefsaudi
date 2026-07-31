import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/contractor.dart';

abstract class ContractorsRemoteDataSource {
  Future<ContractorListResult> getContractors({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<void> createContractor(ContractorWriteRequest request);

  Future<void> updateContractor({
    required String id,
    required ContractorWriteRequest request,
  });

  Future<void> deleteContractor(String id);
}

class ContractorsRemoteDataSourceImpl implements ContractorsRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<ContractorListResult> getContractors({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.supplierListDx,
      query: {
        'addressSearchValue': '',
        'contactSearchValue': '',
        'supplierSearchValue': searchText?.trim() ?? '',
        'skip': skip,
        'take': take,
        'requireTotalCount': true,
      },
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(ContractorDto.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList()
        : <Contractor>[];

    return ContractorListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<void> createContractor(ContractorWriteRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.supplierCreate,
      data: FormData.fromMap({
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> updateContractor({
    required String id,
    required ContractorWriteRequest request,
  }) async {
    await DioHelper.putData(
      url: PmoEndpoints.supplierUpdate,
      data: FormData.fromMap({
        'key': id,
        'values': jsonEncode(request.toJson()),
      }),
    );
  }

  @override
  Future<void> deleteContractor(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.supplierDelete,
      data: FormData.fromMap({'key': id}),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class ContractorDto extends Contractor {
  const ContractorDto({
    required super.id,
    required super.title,
    required super.description,
    required super.currency,
    required super.type,
  });

  factory ContractorDto.fromJson(Map<String, dynamic> json) {
    return ContractorDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      type: _toType(json['type']),
    );
  }

  static int _toType(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

extension ContractorWriteRequestJson on ContractorWriteRequest {
  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
        'currency': currency,
        'description': description,
      };
}
