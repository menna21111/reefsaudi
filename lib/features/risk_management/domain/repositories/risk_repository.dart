import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/project_risk_models.dart';
import '../../../project/data/models/project_api_models.dart';

abstract class RiskRepository {
  Future<Either<Failure, ProjectRiskListResponse>> getProjectRisks({
    int skip = 0,
    int take = 10,
  });

  Future<Either<Failure, void>> createProjectRisk(
    CreateProjectRiskRequest request,
  );

  Future<Either<Failure, List<ProjectDxItemDto>>> getProjects();

  Future<Either<Failure, List<AccountDxItemDto>>> getAccounts();
}
