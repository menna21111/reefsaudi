import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/project_stage_assignment.dart';
import '../../domain/repositories/project_stages_repository.dart';
import '../datasources/project_stages_remote_data_source.dart';

class ProjectStagesRepositoryImpl implements ProjectStagesRepository {
  ProjectStagesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final ProjectStagesRemoteDataSource remoteDataSource;
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
  Future<Either<Failure, ProjectStageListResult>> getProjectStages({
    required int skip,
    required int take,
    String? searchText,
  }) =>
      _guard(
        () => remoteDataSource.getProjectStages(
          skip: skip,
          take: take,
          searchText: searchText,
        ),
      );

  @override
  Future<Either<Failure, List<ProjectStageOption>>> getProjects() =>
      _guard(remoteDataSource.getProjects);

  @override
  Future<Either<Failure, List<ProjectStageOption>>> getStepOptions() =>
      _guard(remoteDataSource.getStepOptions);

  @override
  Future<Either<Failure, void>> createProjectStage(
    ProjectStageWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createProjectStage(request));

  @override
  Future<Either<Failure, void>> updateProjectStage({
    required String id,
    required ProjectStageWriteRequest request,
  }) =>
      _guard(
        () => remoteDataSource.updateProjectStage(id: id, request: request),
      );

  @override
  Future<Either<Failure, void>> deleteProjectStage(String id) =>
      _guard(() => remoteDataSource.deleteProjectStage(id));
}
