import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import '../models/supplier_models.dart';

abstract class AddProjectRemoteDataSource {
  Future<List<SupplierDxItemDto>> getSuppliers({required int type});

  Future<List<AccountDxItemDto>> getAccounts();
}

class AddProjectRemoteDataSourceImpl implements AddProjectRemoteDataSource {
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

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected supplier list response');
    }
    return parseSupplierDxItems(body['data']);
  }

  @override
  Future<List<AccountDxItemDto>> getAccounts() async {
    final response = await DioHelper.getData(url: PmoEndpoints.accountListDx);
    final body = response.data as Map<String, dynamic>;
    return parseAccountDxItems(body['data']);
  }
}
