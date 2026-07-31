import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/permissions/permission_cubit.dart';
import '../../../../core/services/pmo_device_service.dart';
import '../../../../core/services/token_service/token_refresh_service.dart';
import '../../../../core/services/token_service/token_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/profile_model.dart';

class AuthRepositoryImpl {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final TokenStorage tokenStorage;
  final TokenRefreshService tokenRefreshService;
  final PmoDeviceService deviceService;
  final PermissionCubit permissionCubit;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.tokenStorage,
    required this.tokenRefreshService,
    required this.deviceService,
    required this.permissionCubit,
  });

  Future<Either<Failure, ProfileModel>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      await tokenStorage.clearToken();
      await permissionCubit.clear();

      final deviceId = await deviceService.getDeviceId();
      final firebaseToken = await deviceService.getFirebaseToken();

      final loginResult = await remoteDataSource.login(
        email: email,
        password: password,
        deviceId: deviceId,
        firebaseToken: firebaseToken,
      );

      await tokenRefreshService.persistLoginResponse(loginResult);

      final profile = await remoteDataSource.getAccount();
      await tokenStorage.storeUserId(profile.id);
      await permissionCubit.setProfile(profile);

      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _clearSession() async {
    await tokenStorage.clearToken();
    await permissionCubit.clear();
  }

  Future<bool> restoreSession() async {
    final token = await tokenStorage.getToken();
    final hasToken = token != null && token.isNotEmpty;

    if (!hasToken) {
      await _clearSession();
      return false;
    }

    try {
      if (!await networkInfo.isConnected) {
        await permissionCubit.loadCached();
        return permissionCubit.state != null;
      }

      return await _restoreProfileFromServer();
    } catch (_) {
      await _clearSession();
      return false;
    }
  }

  /// Validates the saved token against `/account`.
  /// Only retries after a token refresh on 401/403; any other API error logs out.
  Future<bool> _restoreProfileFromServer() async {
    final firstAttempt = await _tryFetchAndStoreProfile();
    if (firstAttempt) return true;

    final statusCode = _lastAccountStatusCode;
    if (statusCode == 401 || statusCode == 403) {
      final refreshed = await tokenRefreshService.refreshAccessToken();
      if (!refreshed) {
        await _clearSession();
        return false;
      }

      final retryAttempt = await _tryFetchAndStoreProfile();
      if (retryAttempt) return true;
    }

    await _clearSession();
    return false;
  }

  int? _lastAccountStatusCode;

  Future<bool> _tryFetchAndStoreProfile() async {
    _lastAccountStatusCode = null;
    try {
      final profile = await remoteDataSource.getAccount();
      await tokenStorage.storeUserId(profile.id);
      await permissionCubit.setProfile(profile);
      return true;
    } on DioException catch (e) {
      _lastAccountStatusCode = e.response?.statusCode;
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<Either<Failure, ProfileModel>> refreshProfile() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final profile = await remoteDataSource.getAccount();
      await permissionCubit.setProfile(profile);
      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
