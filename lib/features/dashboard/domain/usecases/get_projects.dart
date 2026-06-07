import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../data/models/project_search_request.dart';
import '../../data/models/project_search_response_model.dart';
import '../repositories/dashboard_repository.dart';

class GetProjectsUseCase
    extends UseCase2<ProjectSearchResult, ProjectSearchRequest> {
  final DashboardRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, ProjectSearchResult>> call(
    ProjectSearchRequest params,
  ) async {
    return repository.searchProjects(params);
  }
}

class GetDashboardStatsUseCase
    extends UseCase2<DashboardStats, ProjectSearchRequest> {
  final DashboardRepository repository;

  GetDashboardStatsUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardStats>> call(
    ProjectSearchRequest params,
  ) async {
    return repository.fetchDashboardStats(params);
  }
}
