import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/project_stage_assignment.dart';

abstract class ProjectStagesRepository {
  Future<Either<Failure, ProjectStageListResult>> getProjectStages({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, List<ProjectStageOption>>> getProjects();

  Future<Either<Failure, List<ProjectStageOption>>> getStepOptions();

  Future<Either<Failure, void>> createProjectStage(
    ProjectStageWriteRequest request,
  );

  Future<Either<Failure, void>> updateProjectStage({
    required String id,
    required ProjectStageWriteRequest request,
  });

  Future<Either<Failure, void>> deleteProjectStage(String id);
}
