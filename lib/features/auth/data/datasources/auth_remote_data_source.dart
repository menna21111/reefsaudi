import 'package:flutter/foundation.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/login_response_model.dart';
import '../models/profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String deviceId,
    required String firebaseToken,
  });

  Future<ProfileModel> getAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String deviceId,
    required String firebaseToken,
  }) async {
    final body = {
      'email': email,
      'password': password,
      'deviceId': deviceId,
      'firbaseTokin': firebaseToken,
    };
    debugPrint(
      '🔐 Login body → deviceId=$deviceId | '
      'firbaseTokin=${firebaseToken.isEmpty ? "(empty)" : "${firebaseToken.substring(0, firebaseToken.length.clamp(0, 20))}…"}',
    );

    final response = await DioHelper.postData(
      url: PmoEndpoints.login,
      data: body,
    );
    return LoginResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ProfileModel> getAccount() async {
    final response = await DioHelper.getData(url: PmoEndpoints.account);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}
