import '../../../../core/network/account_list_query.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import '../models/project_edit_models.dart';
import '../models/project_template_models.dart';
import '../models/supplier_models.dart';

abstract class EditProjectRemoteDataSource {
  Future<ProjectEditDto> getProjectForEdit(String projectId);

  Future<List<AccountDxItemDto>> getAccounts();

  Future<List<AccountDxItemDto>> getAccountsByUserType(int userType);

  Future<List<SupplierDxItemDto>> getSuppliers({required int type});

  Future<List<DxListItemDto>> getBrands();

  Future<List<DxListItemDto>> getProducts();

  Future<List<DxListItemDto>> getProjectTypes();

  Future<List<DxListItemDto>> getSizes();

  Future<List<DxListItemDto>> getProductionLines();

  Future<List<ProjectTemplateDto>> getPublishedTemplates();
}

class EditProjectRemoteDataSourceImpl implements EditProjectRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<ProjectEditDto> getProjectForEdit(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectGetForEdit(projectId),
    );
    final body = await _readMapResponse(response.data);
    return ProjectEditDto.fromJson(body);
  }

  @override
  Future<List<AccountDxItemDto>> getAccounts() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.accountListDx,
      query: AccountListQuery.dx(),
    );
    final body = await _readMapResponse(response.data);
    return parseAccountDxItems(body['data']);
  }

  @override
  Future<List<AccountDxItemDto>> getAccountsByUserType(int userType) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.accountListDx,
      query: AccountListQuery.dx(userType: userType),
    );
    final body = await _readMapResponse(response.data);
    return parseAccountDxItems(body['data']);
  }

  @override
  Future<List<SupplierDxItemDto>> getSuppliers({required int type}) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.supplierListDx,
      query: {
        'skip': 0,
        'take': 100,
        'filter': '["type","=",$type]',
      },
    );
    final body = await _readMapResponse(response.data);
    return parseSupplierDxItems(body['data']);
  }

  @override
  Future<List<DxListItemDto>> getBrands() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.brandListDx,
      query: const {'skip': 0, 'take': 100},
    );
    final body = await _readMapResponse(response.data);
    return parseDxListItems(body['data']);
  }

  @override
  Future<List<DxListItemDto>> getProducts() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.productListDx,
      query: const {'skip': 0, 'take': 100},
    );
    final body = await _readMapResponse(response.data);
    return parseDxListItems(body['data']);
  }

  @override
  Future<List<DxListItemDto>> getProjectTypes() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.sizeMlListDx,
      query: const {'skip': 0, 'take': 100},
    );
    final body = await _readMapResponse(response.data);
    return parseDxListItems(body['data']);
  }

  @override
  Future<List<DxListItemDto>> getSizes() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.sizeMlListDx,
      query: const {'skip': 0, 'take': 500},
    );
    final body = await _readMapResponse(response.data);
    return parseDxListItems(body['data']);
  }

  @override
  Future<List<DxListItemDto>> getProductionLines() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.productionLineListDx,
      query: const {'skip': 0, 'take': 100},
    );
    final body = await _readMapResponse(response.data);
    return parseDxListItems(body['data']);
  }

  @override
  Future<List<ProjectTemplateDto>> getPublishedTemplates() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectTemplatePublished,
      query: const {'skip': 0, 'take': 500},
    );
    final body = await _readMapResponse(response.data);
    return parseProjectTemplates(body['data']);
  }
}
