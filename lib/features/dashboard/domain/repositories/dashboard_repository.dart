import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/project_search_request.dart';
import '../../data/models/project_search_response_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, ProjectSearchResult>> searchProjects(
    ProjectSearchRequest request,
  );

  Future<Either<Failure, DashboardStats>> fetchDashboardStats(
    ProjectSearchRequest baseRequest,
  );
}
