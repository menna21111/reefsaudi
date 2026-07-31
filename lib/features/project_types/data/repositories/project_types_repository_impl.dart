import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/project_type.dart';
import '../../domain/repositories/project_types_repository.dart';
import '../datasources/project_types_remote_data_source.dart';

class ProjectTypesRepositoryImpl implements ProjectTypesRepository {
  ProjectTypesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final ProjectTypesRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, ProjectTypeListResult>> getProjectTypes({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getProjectTypes(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, void>> createProjectType(
    ProjectTypeWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createProjectType(request));

  @override
  Future<Either<Failure, void>> updateProjectType({
    required String id,
    required ProjectTypeWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updateProjectType(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deleteProjectType(String id) =>
      _guard(() => remoteDataSource.deleteProjectType(id));
}
