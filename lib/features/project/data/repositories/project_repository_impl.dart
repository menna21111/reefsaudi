import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';
import '../models/project_api_models.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectStatisticsBundle>> getStatisticsBundle(
    String projectId,
  ) async {
    return _guard(() async {
      final results = await Future.wait([
        remoteDataSource.getProjectData(projectId),
        remoteDataSource.getExecutiveSummary(projectId),
        remoteDataSource.getStages(projectId),
        remoteDataSource.getProjectStatements(projectId),
        remoteDataSource.getProjectAchievement(projectId),
        remoteDataSource.getRiskMatrix(projectId),
        remoteDataSource.getQcTechnical(projectId),
        remoteDataSource.getQcAcceptedWork(projectId),
      ]);

      return ProjectStatisticsBundle(
        projectData: results[0] as ProjectDataDto,
        executiveSummary: results[1] as ProjectExecutiveSummaryDto,
        stages: results[2] as List<ProjectStageDto>,
        statements: results[3] as ProjectStatementsDto,
        achievement: results[4] as List<ProjectAchievementPointDto>,
        risks: results[5] as List<RiskMatrixItemDto>,
        qcTechnical: results[6] as List<QcCategoryDto>,
        qcAcceptedWork: results[7] as List<QcCategoryDto>,
      );
    });
  }

  @override
  Future<Either<Failure, ProjectDetailsBundle>> getDetailsBundle(
    String projectId,
  ) async {
    return _guard(() async {
      final results = await Future.wait([
        remoteDataSource.getProjectData(projectId),
        remoteDataSource.getExecutiveSummary(projectId),
        remoteDataSource.getRiskMatrix(projectId),
        remoteDataSource.getProjectAchievement(projectId),
      ]);

      return ProjectDetailsBundle(
        projectData: results[0] as ProjectDataDto,
        executiveSummary: results[1] as ProjectExecutiveSummaryDto,
        risks: results[2] as List<RiskMatrixItemDto>,
        achievement: results[3] as List<ProjectAchievementPointDto>,
      );
    });
  }

  @override
  Future<Either<Failure, AchievementManualListResponse>> getAchievementManual({
    required String projectId,
    int skip = 0,
    int take = 10,
  }) =>
      _guard(
        () => remoteDataSource.getAchievementManual(
          projectId: projectId,
          skip: skip,
          take: take,
        ),
      );

  @override
  Future<Either<Failure, ProjectStatementsDto>> getProjectStatements(
    String projectId,
  ) =>
      _guard(() => remoteDataSource.getProjectStatements(projectId));

  @override
  Future<Either<Failure, List<RiskMatrixItemDto>>> getRiskMatrix(
    String projectId,
  ) =>
      _guard(() => remoteDataSource.getRiskMatrix(projectId));

  @override
  Future<Either<Failure, List<ProjectAchievementPointDto>>> getProjectAchievement(
    String projectId,
  ) =>
      _guard(() => remoteDataSource.getProjectAchievement(projectId));

  @override
  Future<Either<Failure, PaginatedProjectStepsDto>> getProjectSteps({
    required int pageNumber,
  }) =>
      _guard(() => remoteDataSource.getProjectSteps(pageNumber: pageNumber));
}
