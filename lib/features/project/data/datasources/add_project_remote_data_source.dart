import '../../../../core/network/account_list_query.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../risk_management/data/models/project_risk_models.dart';

abstract class AddProjectRemoteDataSource {
  Future<List<AccountDxItemDto>> getAccounts();

  Future<List<AccountDxItemDto>> getAccountsByUserType(int userType);
}

class AddProjectRemoteDataSourceImpl implements AddProjectRemoteDataSource {
  @override
  Future<List<AccountDxItemDto>> getAccounts() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.accountListDx,
      query: AccountListQuery.dx(),
    );
    final body = response.data as Map<String, dynamic>;
    return parseAccountDxItems(body['data']);
  }

  @override
  Future<List<AccountDxItemDto>> getAccountsByUserType(int userType) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.accountListDx,
      query: AccountListQuery.dx(userType: userType),
    );
    final body = response.data as Map<String, dynamic>;
    return parseAccountDxItems(body['data']);
  }
}
