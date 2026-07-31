import '../../../../core/network/account_list_query.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../financial_requirements/data/models/dx_title_item_dto.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../../project/data/models/project_edit_models.dart';
import '../../../project/data/models/supplier_models.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import '../../domain/models/form_building_item.dart';
import '../../domain/models/form_building_module.dart';

abstract class FormBuildingRemoteDataSource {
  Future<FormBuildingListResult> getItems({
    required FormBuildingModule module,
    int skip = 0,
    int take = 100,
  });
}

class FormBuildingRemoteDataSourceImpl implements FormBuildingRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<FormBuildingListResult> getItems({
    required FormBuildingModule module,
    int skip = 0,
    int take = 100,
  }) async {
    switch (module.requestType) {
      case FormBuildingRequestType.dxList:
        return _fetchDxList(module: module, skip: skip, take: take);
      case FormBuildingRequestType.dxTitleList:
        return _fetchDxTitleList(module: module);
      case FormBuildingRequestType.accounts:
        return _fetchAccounts(module: module, skip: skip, take: take);
      case FormBuildingRequestType.suppliers:
        return _fetchSuppliers(module: module, skip: skip, take: take);
      case FormBuildingRequestType.projectSteps:
        return _fetchProjectSteps(module: module);
    }
  }

  Future<FormBuildingListResult> _fetchDxList({
    required FormBuildingModule module,
    required int skip,
    required int take,
  }) async {
    final response = await DioHelper.getData(
      url: module.endpoint,
      query: {'skip': skip, 'take': take, 'requireTotalCount': true},
    );
    final body = await _readMapResponse(response.data);
    final items = parseDxListItems(
      body['data'],
    ).map((item) => FormBuildingItem(id: item.id, title: item.title)).toList();

    return FormBuildingListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  Future<FormBuildingListResult> _fetchDxTitleList({
    required FormBuildingModule module,
  }) async {
    final response = await DioHelper.getData(url: module.endpoint);
    final body = await _readMapResponse(response.data);
    final items = parseDxTitleItems(body['data'])
        .map(
          (item) => FormBuildingItem(
            id: item.id,
            title: item.title,
            subtitle: item.description,
          ),
        )
        .toList();

    return FormBuildingListResult(items: items, totalCount: items.length);
  }

  Future<FormBuildingListResult> _fetchAccounts({
    required FormBuildingModule module,
    required int skip,
    required int take,
  }) async {
    final response = await DioHelper.getData(
      url: module.endpoint,
      query: AccountListQuery.dx(
        skip: skip,
        take: take,
        userType: module.accountUserType,
      ),
    );
    final body = await _readMapResponse(response.data);
    final items = parseAccountDxItems(body['data'])
        .map((item) => FormBuildingItem(id: item.id, title: item.fullName))
        .toList();

    return FormBuildingListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  Future<FormBuildingListResult> _fetchSuppliers({
    required FormBuildingModule module,
    required int skip,
    required int take,
  }) async {
    final response = await DioHelper.getData(
      url: module.endpoint,
      query: {
        'skip': skip,
        'take': take,
        'requireTotalCount': true,
        if (module.supplierType != null)
          'filter': '["type","=",${module.supplierType}]',
      },
    );
    final body = await _readMapResponse(response.data);
    final items = parseSupplierDxItems(
      body['data'],
    ).map((item) => FormBuildingItem(id: item.id, title: item.title)).toList();

    return FormBuildingListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  Future<FormBuildingListResult> _fetchProjectSteps({
    required FormBuildingModule module,
  }) async {
    final response = await DioHelper.getData(url: module.endpoint);
    final body = await _readMapResponse(response.data);
    final items = parseProjectStepItems(body['data'])
        .map(
          (item) => FormBuildingItem(
            id: item.id,
            title: item.pStepTitle,
            subtitle: item.projectTitle,
          ),
        )
        .toList();

    return FormBuildingListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
