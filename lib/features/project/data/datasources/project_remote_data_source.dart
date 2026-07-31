import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/project_api_models.dart';
import '../models/project_charter_models.dart';
import '../models/achievement_manual_request.dart';
import 'package:dio/dio.dart';

Map<String, dynamic>? _responseAsMap(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  return null;
}

String? _messageFromResponse(dynamic data) {
  final body = _responseAsMap(data);
  if (body == null) return null;

  final msg = body['message'];
  if (msg is String && msg.trim().isNotEmpty) return msg.trim();
  if (msg is List && msg.isNotEmpty) return msg.first.toString();

  return null;
}

abstract class ProjectRemoteDataSource {
  Future<ProjectDataDto> getProjectData(String projectId);
  Future<ProjectExecutiveSummaryDto?> getExecutiveSummary(String projectId);
  Future<List<ProjectStageDto>> getStages(String projectId);
  Future<ProjectStatementsDto> getProjectStatements(String projectId);
  Future<List<ProjectAchievementPointDto>> getProjectAchievement(String projectId);
  Future<List<ProjectImageDto>> getProjectImages(String projectId);
  Future<List<RiskMatrixItemDto>> getRiskMatrix(String projectId);
  Future<List<QcCategoryDto>> getQcTechnical(String projectId);
  Future<List<QcCategoryDto>> getQcAcceptedWork(String projectId);
  Future<AchievementManualListResponse> getAchievementManual({
    required String projectId,
    int skip = 0,
    int take = 10,
  });
  Future<void> createAchievementManual(CreateAchievementManualRequest request);
  Future<void> updateAchievementManual(UpdateAchievementManualRequest request);
  Future<void> deleteAchievementManual(String key);
  Future<DxListResponse<ProjectDxItemDto>> getProjectDxList();
  Future<DxListResponse<ProjectStepItemDto>> getProjectStepsDxList();
  Future<PaginatedProjectStepsDto> getProjectSteps({required int pageNumber});
  Future<ProjectStepItemDto> getProjectStepById(String id);
  Future<String> createProject(FormData data);
  Future<String?> updateProject(
    String projectId,
    Map<String, dynamic> data,
  );
  Future<ProjectCharterDetailsDto> getProjectCharter(String projectId);
  Future<CharterPagedResponse<CharterAchievementDto>> getCharterAchievements(
    String projectId,
    {String? search,}
  );
  Future<void> createCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  );
  Future<void> updateCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  );
  Future<void> deleteCharterAchievement(String projectId, String key);
  Future<CharterPagedResponse<CharterStageDto>> getCharterStages(
    String projectId,
    {String? search,}
  );
  Future<void> createCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  );
  Future<void> updateCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  );
  Future<void> deleteCharterStage(String projectId, String key);
  Future<CharterPagedResponse<CharterConstraintDto>> getCharterConstraints(
    String projectId,
    {String? search,}
  );
  Future<void> createCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  );
  Future<void> updateCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  );
  Future<void> deleteCharterConstraint(String projectId, String key);
  Future<List<CharterAttachmentDto>> getCharterAttachments(
    String projectId, {
    String? search,
  });
  Future<void> uploadCharterAttachment(String projectId, MultipartFile file);
  Future<void> deleteCharterAttachment(String projectId, String key);
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
  Future<List<ProjectImageDto>> getProjectImages(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectImages(projectId),
      responseType: ResponseType.json,
    );
    return parseProjectImages(response.data);
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
  Future<void> createAchievementManual(
    CreateAchievementManualRequest request,
  ) async {
    await DioHelper.postData(
      url: PmoEndpoints.achievementManualCreate,
      data: request.toFormData(),
    );
  }

  @override
  Future<void> updateAchievementManual(
    UpdateAchievementManualRequest request,
  ) async {
    await DioHelper.putData(
      url: PmoEndpoints.achievementManualUpdate,
      data: request.toFormData(),
    );
  }

  @override
  Future<void> deleteAchievementManual(String key) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.achievementManualDelete,
      data: FormData.fromMap({'key': key}),
    );
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

  @override
  Future<String> createProject(FormData data) async {
    final response = await DioHelper.postData(
      url: PmoEndpoints.createProject,
      data: data,
    );
    final body = _responseAsMap(response.data);
    if (body != null) {
      final id = body['id']?.toString();
      if (id != null && id.isNotEmpty) return id;
    }
    return response.data?.toString() ?? '';
  }

  @override
  Future<String?> updateProject(
    String projectId,
    Map<String, dynamic> data,
  ) async {
    final response = await DioHelper.putData(
      url: PmoEndpoints.projectById(projectId),
      data: data,
    );
    return _messageFromResponse(response.data);
  }

  static const _charterStagesSort =
      '[{"selector":"date","desc":true}]';

  @override
  Future<ProjectCharterDetailsDto> getProjectCharter(String projectId) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectCharterByProjectId(projectId),
      responseType: ResponseType.json,
    );
    final body = _responseAsMap(response.data);
    if (body == null) {
      throw const FormatException('Unexpected project charter response');
    }
    return ProjectCharterDetailsDto.fromJson(body);
  }

  Future<CharterPagedResponse<T>> _fetchCharterPaged<T>({
    required String url,
    required Map<String, dynamic> query,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await DioHelper.getData(
      url: url,
      query: query,
      responseType: ResponseType.json,
    );
    return parseCharterPagedResponse(response.data, fromJson);
  }

  @override
  Future<CharterPagedResponse<CharterAchievementDto>> getCharterAchievements(
    String projectId,
    {String? search,}
  ) =>
      _fetchCharterPaged(
        url: PmoEndpoints.projectCharterAchievements(projectId),
        query: charterSearchQuery(search),
        fromJson: CharterAchievementDto.fromJson,
      );

  @override
  Future<void> createCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  ) async {
    await DioHelper.postData(
      url: PmoEndpoints.projectCharterAchievements(projectId),
      data: request.toCreateFormData(),
    );
  }

  @override
  Future<void> updateCharterAchievement(
    String projectId,
    CharterTextWriteRequest request,
  ) async {
    await DioHelper.putData(
      url: PmoEndpoints.projectCharterAchievements(projectId),
      data: request.toUpdateFormData(),
    );
  }

  @override
  Future<void> deleteCharterAchievement(String projectId, String key) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.projectCharterAchievements(projectId),
      data: FormData.fromMap({'key': key}),
    );
  }

  @override
  Future<CharterPagedResponse<CharterStageDto>> getCharterStages(
    String projectId,
    {String? search,}
  ) async {
    final response = await _fetchCharterPaged<CharterStageDto>(
      url: PmoEndpoints.projectCharterStages(projectId),
      query: {
        ...charterSearchQuery(search),
        'sort': _charterStagesSort,
      },
      fromJson: CharterStageDto.fromJson,
    );
    final sortedStages = List<CharterStageDto>.from(response.data)
      ..sort((a, b) {
        final aDate = DateTime.tryParse(a.date ?? '') ?? DateTime(1970);
        final bDate = DateTime.tryParse(b.date ?? '') ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    return CharterPagedResponse(
      data: sortedStages,
      totalCount: response.totalCount,
    );
  }

  @override
  Future<void> createCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  ) async {
    await DioHelper.postData(
      url: PmoEndpoints.projectCharterStages(projectId),
      data: request.toCreateFormData(),
    );
  }

  @override
  Future<void> updateCharterStage(
    String projectId,
    CharterStageWriteRequest request,
  ) async {
    await DioHelper.putData(
      url: PmoEndpoints.projectCharterStages(projectId),
      data: request.toUpdateFormData(),
    );
  }

  @override
  Future<void> deleteCharterStage(String projectId, String key) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.projectCharterStages(projectId),
      data: FormData.fromMap({'key': key}),
    );
  }

  @override
  Future<CharterPagedResponse<CharterConstraintDto>> getCharterConstraints(
    String projectId,
    {String? search,}
  ) =>
      _fetchCharterPaged(
        url: PmoEndpoints.projectCharterConstraints(projectId),
        query: charterSearchQuery(search),
        fromJson: CharterConstraintDto.fromJson,
      );

  @override
  Future<void> createCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  ) async {
    await DioHelper.postData(
      url: PmoEndpoints.projectCharterConstraints(projectId),
      data: request.toCreateFormData(),
    );
  }

  @override
  Future<void> updateCharterConstraint(
    String projectId,
    CharterConstraintWriteRequest request,
  ) async {
    await DioHelper.putData(
      url: PmoEndpoints.projectCharterConstraints(projectId),
      data: request.toUpdateFormData(),
    );
  }

  @override
  Future<void> deleteCharterConstraint(String projectId, String key) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.projectCharterConstraints(projectId),
      data: FormData.fromMap({'key': key}),
    );
  }

  @override
  Future<List<CharterAttachmentDto>> getCharterAttachments(
    String projectId, {
    String? search,
  }
  ) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectCharterAttachments(projectId),
      query: charterSearchQuery(search),
      responseType: ResponseType.json,
    );
    return parseCharterAttachments(response.data);
  }

  @override
  Future<void> uploadCharterAttachment(
    String projectId,
    MultipartFile file,
  ) async {
    await DioHelper.postData(
      url: PmoEndpoints.projectCharterAttachments(projectId),
      data: FormData.fromMap({'file': file}),
    );
  }

  @override
  Future<void> deleteCharterAttachment(String projectId, String key) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.projectCharterAttachments(projectId),
      data: FormData.fromMap({'key': key}),
    );
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
