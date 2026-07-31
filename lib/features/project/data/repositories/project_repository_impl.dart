import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';
import '../models/project_api_models.dart';
import '../models/project_charter_models.dart';
import '../models/create_project_request.dart';
import '../models/update_project_request.dart';
import '../models/achievement_manual_request.dart';

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

  Future<ProjectExecutiveSummaryDto> _loadExecutiveSummary(
    String projectId,
    ProjectDataDto projectData,
  ) async {
    final summary = await remoteDataSource.getExecutiveSummary(projectId);
    return summary ?? ProjectExecutiveSummaryDto.fromProjectData(projectData);
  }

  @override
  Future<Either<Failure, ProjectStatisticsBundle>> getStatisticsBundle(
    String projectId,
  ) async {
    return _guard(() async {
      final projectData = await remoteDataSource.getProjectData(projectId);
      final executiveSummary = await _loadExecutiveSummary(projectId, projectData);

      final results = await Future.wait([
        remoteDataSource.getStages(projectId),
        remoteDataSource.getProjectStatements(projectId),
        remoteDataSource.getProjectAchievement(projectId),
        remoteDataSource.getRiskMatrix(projectId),
        remoteDataSource.getQcTechnical(projectId),
        remoteDataSource.getQcAcceptedWork(projectId),
      ]);

      return ProjectStatisticsBundle(
        projectData: projectData,
        executiveSummary: executiveSummary,
        stages: results[0] as List<ProjectStageDto>,
        statements: results[1] as ProjectStatementsDto,
        achievement: results[2] as List<ProjectAchievementPointDto>,
        risks: results[3] as List<RiskMatrixItemDto>,
        qcTechnical: results[4] as List<QcCategoryDto>,
        qcAcceptedWork: results[5] as List<QcCategoryDto>,
      );
    });
  }

  @override
  Future<Either<Failure, ProjectDataDto>> getProjectData(String projectId) =>
      _guard(() => remoteDataSource.getProjectData(projectId));

  @override
  Future<Either<Failure, ProjectExecutiveSummaryDto?>> getExecutiveSummary(
    String projectId,
  ) =>
      _guard(() => remoteDataSource.getExecutiveSummary(projectId));

  @override
  Future<Either<Failure, ProjectDetailsBundle>> getDetailsBundle(
    String projectId,
  ) async {
    return _guard(() async {
      final projectData = await remoteDataSource.getProjectData(projectId);
      final executiveSummary = await _loadExecutiveSummary(projectId, projectData);

      final results = await Future.wait([
        remoteDataSource.getRiskMatrix(projectId),
        remoteDataSource.getProjectAchievement(projectId),
      ]);

      return ProjectDetailsBundle(
        projectData: projectData,
        executiveSummary: executiveSummary,
        risks: results[0] as List<RiskMatrixItemDto>,
        achievement: results[1] as List<ProjectAchievementPointDto>,
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
  Future<Either<Failure, void>> createAchievementManual(
    CreateAchievementManualRequest request,
  ) =>
      _guard(() => remoteDataSource.createAchievementManual(request));

  @override
  Future<Either<Failure, void>> updateAchievementManual(
    UpdateAchievementManualRequest request,
  ) =>
      _guard(() => remoteDataSource.updateAchievementManual(request));

  @override
  Future<Either<Failure, void>> deleteAchievementManual(String key) =>
      _guard(() => remoteDataSource.deleteAchievementManual(key));

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
  Future<Either<Failure, List<ProjectImageDto>>> getProjectImages(
    String projectId,
  ) =>
      _guard(() => remoteDataSource.getProjectImages(projectId));

  @override
  Future<Either<Failure, PaginatedProjectStepsDto>> getProjectSteps({
    required int pageNumber,
  }) =>
      _guard(() => remoteDataSource.getProjectSteps(pageNumber: pageNumber));

  @override
  Future<Either<Failure, String>> createProject(
    CreateProjectRequest request,
  ) =>
      _guard(() => remoteDataSource.createProject(request.toFormData()));

  @override
  Future<Either<Failure, String?>> updateProject(
    UpdateProjectRequest request,
  ) =>
      _guard(
        () => remoteDataSource.updateProject(request.id, request.toJson()),
      );

  @override
  Future<Either<Failure, ProjectCharterDetailsDto>> getProjectCharter(
    String projectId,
  ) =>
      _guard(() => remoteDataSource.getProjectCharter(projectId));

  @override
  Future<Either<Failure, CharterPagedResponse<CharterAchievementDto>>>
      getCharterAchievements(String projectId, {String? search}) => _guard(
        () => remoteDataSource.getCharterAchievements(
          projectId,
          search: search,
        ),
      );

  @override
  Future<Either<Failure, void>> createCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createCharterAchievement(projectId, request));

  @override
  Future<Either<Failure, void>> updateCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.updateCharterAchievement(projectId, request));

  @override
  Future<Either<Failure, void>> deleteCharterAchievement(
    String projectId,
    String key,
  ) =>
      _guard(() => remoteDataSource.deleteCharterAchievement(projectId, key));

  @override
  Future<Either<Failure, CharterPagedResponse<CharterStageDto>>>
      getCharterStages(String projectId, {String? search}) => _guard(
        () => remoteDataSource.getCharterStages(
          projectId,
          search: search,
        ),
      );

  @override
  Future<Either<Failure, void>> createCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createCharterStage(projectId, request));

  @override
  Future<Either<Failure, void>> updateCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.updateCharterStage(projectId, request));

  @override
  Future<Either<Failure, void>> deleteCharterStage(String projectId, String key) =>
      _guard(() => remoteDataSource.deleteCharterStage(projectId, key));

  @override
  Future<Either<Failure, CharterPagedResponse<CharterConstraintDto>>>
      getCharterConstraints(String projectId, {String? search}) => _guard(
        () => remoteDataSource.getCharterConstraints(
          projectId,
          search: search,
        ),
      );

  @override
  Future<Either<Failure, void>> createCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.createCharterConstraint(projectId, request));

  @override
  Future<Either<Failure, void>> updateCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  ) =>
      _guard(() => remoteDataSource.updateCharterConstraint(projectId, request));

  @override
  Future<Either<Failure, void>> deleteCharterConstraint(
    String projectId,
    String key,
  ) =>
      _guard(() => remoteDataSource.deleteCharterConstraint(projectId, key));

  @override
  Future<Either<Failure, List<CharterAttachmentDto>>> getCharterAttachments(
    String projectId,
    {String? search}
  ) =>
      _guard(
        () => remoteDataSource.getCharterAttachments(projectId, search: search),
      );

  @override
  Future<Either<Failure, void>> uploadCharterAttachment(
    String projectId,
    String filePath,
  ) =>
      _guard(() async {
        final file = await MultipartFile.fromFile(filePath);
        await remoteDataSource.uploadCharterAttachment(projectId, file);
      });

  @override
  Future<Either<Failure, void>> deleteCharterAttachment(
    String projectId,
    String key,
  ) =>
      _guard(() => remoteDataSource.deleteCharterAttachment(projectId, key));
}
