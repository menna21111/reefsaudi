import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/role.dart';
import '../../domain/repositories/roles_repository.dart';
import '../datasources/roles_remote_data_source.dart';

class RolesRepositoryImpl implements RolesRepository {
  RolesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final RolesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }
    try {
      return Right(await call());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, RoleListResult>> getRoles({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getRoles(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createRole(RoleWriteRequest request) =>
      _guard(() => remoteDataSource.createRole(request));

  @override
  Future<Either<Failure, RoleDetails>> getRoleDetails(String roleId) =>
      _guard(() => remoteDataSource.getRoleDetails(roleId));

  @override
  Future<Either<Failure, void>> updateRole(RoleUpdateRequest request) =>
      _guard(() => remoteDataSource.updateRole(request));
}
