import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/pmo_project_dto.dart';
import '../models/project_search_request.dart';
import '../models/project_search_response_model.dart';

abstract class DashboardRemoteDataSource {
  Future<ProjectSearchResult> searchProjects(ProjectSearchRequest request);

  Future<DashboardStats> fetchDashboardStats(ProjectSearchRequest baseRequest);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<ProjectSearchResult> searchProjects(
    ProjectSearchRequest request,
  ) async {
    final response = await DioHelper.postData(
      url: PmoEndpoints.projectSearch,
      data: request.toJson(),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project search response');
    }

    final dto = ProjectSearchResponseDto.fromJson(body);
    return ProjectSearchResult.fromDto(
      dto,
      withStats: request.includeAggs,
    );
  }

  @override
  Future<DashboardStats> fetchDashboardStats(
    ProjectSearchRequest baseRequest,
  ) async {
    final aggsRequest = baseRequest.copyWith(
      page: 1,
      size: 1,
      includeAggs: true,
      aggsOnly: false,
    );

    final aggsResponse = await DioHelper.postData(
      url: PmoEndpoints.projectSearch,
      data: aggsRequest.toJson(),
    );

    final aggsBody = aggsResponse.data;
    if (aggsBody is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project search response');
    }

    final aggsDto = ProjectSearchResponseDto.fromJson(aggsBody);
    var stats = DashboardStats.fromDto(aggsDto);

    if (stats.total <= 0) return stats;

    final budgetRequest = baseRequest.copyWith(
      page: 1,
      size: stats.total,
      includeAggs: false,
      aggsOnly: false,
    );

    final budgetResponse = await DioHelper.postData(
      url: PmoEndpoints.projectSearch,
      data: budgetRequest.toJson(),
    );

    final budgetBody = budgetResponse.data;
    if (budgetBody is Map<String, dynamic>) {
      final budgetDto = ProjectSearchResponseDto.fromJson(budgetBody);
      final totalBudget = budgetDto.data.fold<double>(
        0,
        (sum, project) => sum + project.quantity.toDouble(),
      );
      stats = stats.copyWith(totalBudget: totalBudget);
    }

    return stats;
  }
}
