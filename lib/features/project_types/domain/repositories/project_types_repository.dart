import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/project_type.dart';

abstract class ProjectTypesRepository {
  Future<Either<Failure, ProjectTypeListResult>> getProjectTypes({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createProjectType(
    ProjectTypeWriteRequest request,
  );

  Future<Either<Failure, void>> updateProjectType({
    required String id,
    required ProjectTypeWriteRequest request,
  });

  Future<Either<Failure, void>> deleteProjectType(String id);
}
