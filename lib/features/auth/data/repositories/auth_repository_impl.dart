import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/pmo_device_service.dart';
import '../../../../core/services/token_service/token_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/account_model.dart';

class AuthRepositoryImpl {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final TokenStorage tokenStorage;
  final PmoDeviceService deviceService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.tokenStorage,
    required this.deviceService,
  });

  Future<Either<Failure, AccountModel>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No Internet Connection'));
    }

    try {
      await tokenStorage.clearToken();

      final deviceId = await deviceService.getDeviceId();
      final firebaseToken = await deviceService.getFirebaseToken();

      final loginResult = await remoteDataSource.login(
        email: email,
        password: password,
        deviceId: deviceId,
        firebaseToken: firebaseToken,
      );

      await tokenStorage.storeToken(loginResult.accessToken);
      if (loginResult.refreshToken != null) {
        await tokenStorage.storeRefreshToken(loginResult.refreshToken!);
      }

      final account = await remoteDataSource.getAccount();
      await tokenStorage.storeUserId(account.id);

      return Right(account);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
