import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/employee.dart';
import '../../domain/repositories/employees_repository.dart';
import '../datasources/employees_remote_data_source.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  EmployeesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final EmployeesRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, EmployeeListResult>> getEmployees({
    required int skip,
    required int take,
    String? searchText,
  }) => _guard(
    () => remoteDataSource.getEmployees(
      skip: skip,
      take: take,
      searchText: searchText,
    ),
  );

  @override
  Future<Either<Failure, List<EmployeeOption>>> getDesignations() =>
      _guard(remoteDataSource.getDesignations);

  @override
  Future<Either<Failure, List<EmployeeOption>>> getDepartments() =>
      _guard(remoteDataSource.getDepartments);

  @override
  Future<Either<Failure, List<EmployeeOption>>> getRoles() =>
      _guard(remoteDataSource.getRoles);

  @override
  Future<Either<Failure, List<EmployeeOption>>> getSupervisors() =>
      _guard(remoteDataSource.getSupervisors);

  @override
  Future<Either<Failure, void>> createEmployee(EmployeeCreateRequest request) =>
      _guard(() => remoteDataSource.createEmployee(request));

  @override
  Future<Either<Failure, void>> updateEmployee(EmployeeUpdateRequest request) =>
      _guard(() => remoteDataSource.updateEmployee(request));

  @override
  Future<Either<Failure, void>> resetPassword({
    required String userId,
    required String newPassword,
  }) => _guard(
    () => remoteDataSource.resetPassword(
      userId: userId,
      newPassword: newPassword,
    ),
  );

  @override
  Future<Either<Failure, void>> deleteEmployee(String userId) =>
      _guard(() => remoteDataSource.deleteEmployee(userId));
}
