import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/project_api_models.dart';
import '../../data/models/project_charter_models.dart';
import '../../data/models/create_project_request.dart';
import '../../data/models/update_project_request.dart';
import '../../data/models/achievement_manual_request.dart';

class ProjectStatisticsBundle {
  final ProjectDataDto projectData;
  final ProjectExecutiveSummaryDto executiveSummary;
  final List<ProjectStageDto> stages;
  final ProjectStatementsDto statements;
  final List<ProjectAchievementPointDto> achievement;
  final List<RiskMatrixItemDto> risks;
  final List<QcCategoryDto> qcTechnical;
  final List<QcCategoryDto> qcAcceptedWork;

  const ProjectStatisticsBundle({
    required this.projectData,
    required this.executiveSummary,
    required this.stages,
    required this.statements,
    required this.achievement,
    required this.risks,
    required this.qcTechnical,
    required this.qcAcceptedWork,
  });
}

class ProjectDetailsBundle {
  final ProjectDataDto projectData;
  final ProjectExecutiveSummaryDto executiveSummary;
  final List<RiskMatrixItemDto> risks;
  final List<ProjectAchievementPointDto> achievement;

  const ProjectDetailsBundle({
    required this.projectData,
    required this.executiveSummary,
    required this.risks,
    required this.achievement,
  });
}

abstract class ProjectRepository {
  Future<Either<Failure, ProjectStatisticsBundle>> getStatisticsBundle(
    String projectId,
  );

  Future<Either<Failure, ProjectDetailsBundle>> getDetailsBundle(
    String projectId,
  );

  Future<Either<Failure, ProjectDataDto>> getProjectData(String projectId);

  Future<Either<Failure, ProjectExecutiveSummaryDto?>> getExecutiveSummary(
    String projectId,
  );

  Future<Either<Failure, AchievementManualListResponse>> getAchievementManual({
    required String projectId,
    int skip = 0,
    int take = 10,
  });

  Future<Either<Failure, void>> createAchievementManual(
    CreateAchievementManualRequest request,
  );

  Future<Either<Failure, void>> updateAchievementManual(
    UpdateAchievementManualRequest request,
  );

  Future<Either<Failure, void>> deleteAchievementManual(String key);

  Future<Either<Failure, ProjectStatementsDto>> getProjectStatements(
    String projectId,
  );

  Future<Either<Failure, List<RiskMatrixItemDto>>> getRiskMatrix(
    String projectId,
  );

  Future<Either<Failure, List<ProjectAchievementPointDto>>> getProjectAchievement(
    String projectId,
  );

  Future<Either<Failure, List<ProjectImageDto>>> getProjectImages(
    String projectId,
  );

  Future<Either<Failure, PaginatedProjectStepsDto>> getProjectSteps({
    required int pageNumber,
  });

  Future<Either<Failure, String>> createProject(CreateProjectRequest request);

  Future<Either<Failure, String?>> updateProject(UpdateProjectRequest request);

  Future<Either<Failure, ProjectCharterDetailsDto>> getProjectCharter(
    String projectId,
  );

  Future<Either<Failure, CharterPagedResponse<CharterAchievementDto>>>
      getCharterAchievements(String projectId, {String? search});
  Future<Either<Failure, void>> createCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  );
  Future<Either<Failure, void>> updateCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  );
  Future<Either<Failure, void>> deleteCharterAchievement(
    String projectId,
    String key,
  );

  Future<Either<Failure, CharterPagedResponse<CharterStageDto>>>
      getCharterStages(String projectId, {String? search});
  Future<Either<Failure, void>> createCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  );
  Future<Either<Failure, void>> updateCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  );
  Future<Either<Failure, void>> deleteCharterStage(String projectId, String key);

  Future<Either<Failure, CharterPagedResponse<CharterConstraintDto>>>
      getCharterConstraints(String projectId, {String? search});
  Future<Either<Failure, void>> createCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  );
  Future<Either<Failure, void>> updateCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  );
  Future<Either<Failure, void>> deleteCharterConstraint(
    String projectId,
    String key,
  );

  Future<Either<Failure, List<CharterAttachmentDto>>> getCharterAttachments(
    String projectId,
    {String? search}
  );
  Future<Either<Failure, void>> uploadCharterAttachment(
    String projectId,
    String filePath,
  );
  Future<Either<Failure, void>> deleteCharterAttachment(
    String projectId,
    String key,
  );
}
