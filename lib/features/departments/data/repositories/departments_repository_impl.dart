import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/department.dart';
import '../../domain/repositories/departments_repository.dart';
import '../datasources/departments_remote_data_source.dart';

class DepartmentsRepositoryImpl implements DepartmentsRepository {
  DepartmentsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final DepartmentsRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, DepartmentListResult>> getDepartments({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getDepartments(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createDepartment(
    DepartmentWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createDepartment(request));

  @override
  Future<Either<Failure, void>> updateDepartment({
    required String id,
    required DepartmentWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updateDepartment(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deleteDepartment(String id) =>
      _guard(() => remoteDataSource.deleteDepartment(id));
}
