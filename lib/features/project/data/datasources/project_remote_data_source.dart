import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/project_api_models.dart';

Map<String, dynamic>? _responseAsMap(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  return null;
}

abstract class ProjectRemoteDataSource {
  Future<ProjectDataDto> getProjectData(String projectId);
  Future<ProjectExecutiveSummaryDto?> getExecutiveSummary(String projectId);
  Future<List<ProjectStageDto>> getStages(String projectId);
  Future<ProjectStatementsDto> getProjectStatements(String projectId);
  Future<List<ProjectAchievementPointDto>> getProjectAchievement(String projectId);
  Future<List<RiskMatrixItemDto>> getRiskMatrix(String projectId);
  Future<List<QcCategoryDto>> getQcTechnical(String projectId);
  Future<List<QcCategoryDto>> getQcAcceptedWork(String projectId);
  Future<AchievementManualListResponse> getAchievementManual({
    required String projectId,
    int skip = 0,
    int take = 10,
  });
  Future<DxListResponse<ProjectDxItemDto>> getProjectDxList();
  Future<DxListResponse<ProjectStepItemDto>> getProjectStepsDxList();
  Future<PaginatedProjectStepsDto> getProjectSteps({required int pageNumber});
  Future<ProjectStepItemDto> getProjectStepById(String id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  @override
  Future<ProjectDataDto> getProjectData(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectData(projectId),
    );
    final body = _responseAsMap(response.data);
    if (body == null) {
      throw FormatException('Unexpected project-data response: ${response.data}');
    }
    return ProjectDataDto.fromJson(body);
  }

  @override
  Future<ProjectExecutiveSummaryDto?> getExecutiveSummary(
    String projectId,
  ) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectExecutiveSummary(projectId),
    );
    if (response.statusCode == 204) return null;

    final body = _responseAsMap(response.data);
    if (body == null) return null;

    return ProjectExecutiveSummaryDto.fromJson(body);
  }

  @override
  Future<List<ProjectStageDto>> getStages(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStages(projectId),
    );
    return parseProjectStages(response.data);
  }

  @override
  Future<ProjectStatementsDto> getProjectStatements(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStatements(projectId),
    );
    if (response.statusCode == 204) return ProjectStatementsDto.empty();

    final body = _responseAsMap(response.data);
    if (body == null) return ProjectStatementsDto.empty();

    return ProjectStatementsDto.fromJson(body);
  }

  @override
  Future<List<ProjectAchievementPointDto>> getProjectAchievement(
    String projectId,
  ) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectAchievement(projectId),
    );
    return parseProjectAchievement(response.data);
  }

  @override
  Future<List<RiskMatrixItemDto>> getRiskMatrix(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRiskMatrix(projectId),
    );
    return parseRiskMatrix(response.data);
  }

  @override
  Future<List<QcCategoryDto>> getQcTechnical(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectQcTechnical(projectId),
    );
    return parseQcCategories(response.data);
  }

  @override
  Future<List<QcCategoryDto>> getQcAcceptedWork(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectQcAcceptedWork(projectId),
    );
    return parseQcCategories(response.data);
  }

  @override
  Future<AchievementManualListResponse> getAchievementManual({
    required String projectId,
    int skip = 0,
    int take = 10,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.achievementManualListDx,
      query: {
        'projectId': projectId,
        'skip': skip,
        'take': take,
        'requireTotalCount': true,
        'sort': '[{"selector":"monthYear","desc":true}]',
      },
    );

    final body = _responseAsMap(response.data);
    if (body == null) {
      throw const FormatException('Unexpected achievement manual response');
    }
    return AchievementManualListResponse.fromJson(body);
  }

  @override
  Future<DxListResponse<ProjectDxItemDto>> getProjectDxList() async {
    final response = await DioHelper.getData(url: PmoEndpoints.projectDxList);
    final body = _responseAsMap(response.data);
    if (body == null) {
      return const DxListResponse(data: [], totalCount: 0);
    }
    return DxListResponse(
      data: parseProjectDxItems(body['data']),
      totalCount: _toInt(body['totalCount']),
    );
  }

  @override
  Future<DxListResponse<ProjectStepItemDto>> getProjectStepsDxList() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStepListDx,
    );
    final body = _responseAsMap(response.data);
    if (body == null) {
      return const DxListResponse(data: [], totalCount: 0);
    }
    return DxListResponse(
      data: parseProjectStepItems(body['data']),
      totalCount: _toInt(body['totalCount']),
    );
  }

  @override
  Future<PaginatedProjectStepsDto> getProjectSteps({
    required int pageNumber,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectSteps,
      query: {'pageNumber': pageNumber},
    );
    final body = _responseAsMap(response.data);
    if (body == null) {
      throw FormatException('Unexpected project steps response: ${response.data}');
    }
    return PaginatedProjectStepsDto.fromJson(body);
  }

  @override
  Future<ProjectStepItemDto> getProjectStepById(String id) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStepById(id),
    );
    final body = _responseAsMap(response.data);
    if (body == null) {
      throw FormatException('Unexpected project step response: ${response.data}');
    }
    final items = parseProjectStepItems(body['items']);
    if (items.isEmpty) {
      throw FormatException('Project step not found: $id');
    }
    return items.first;
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
