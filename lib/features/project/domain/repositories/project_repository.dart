import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/project_api_models.dart';

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

  Future<Either<Failure, AchievementManualListResponse>> getAchievementManual({
    required String projectId,
    int skip = 0,
    int take = 10,
  });

  Future<Either<Failure, ProjectStatementsDto>> getProjectStatements(
    String projectId,
  );

  Future<Either<Failure, List<RiskMatrixItemDto>>> getRiskMatrix(
    String projectId,
  );

  Future<Either<Failure, List<ProjectAchievementPointDto>>> getProjectAchievement(
    String projectId,
  );

  Future<Either<Failure, PaginatedProjectStepsDto>> getProjectSteps({
    required int pageNumber,
  });
}
