import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/account_model.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String deviceId,
    required String firebaseToken,
  });

  Future<AccountModel> getAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  

  AuthRemoteDataSourceImpl();

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String deviceId,
    required String firebaseToken,
  }) async {
    final response = await DioHelper.postData(
      url: PmoEndpoints.login,
      data: {
        'email': email,
        'password': password,
        'deviceId': deviceId,
        'firbaseTokin': firebaseToken,
      },
    );
    return LoginResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<AccountModel> getAccount() async {
    final response = await DioHelper.getData(url: PmoEndpoints.account);
    return AccountModel.fromJson(response.data as Map<String, dynamic>);
  }
}
