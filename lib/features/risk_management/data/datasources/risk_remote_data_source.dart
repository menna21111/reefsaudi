import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../project/data/models/project_api_models.dart';
import '../models/project_risk_models.dart';

abstract class RiskRemoteDataSource {
  Future<ProjectRiskListResponse> getProjectRisks({
    int skip = 0,
    int take = 10,
    String? searchText,
  });

  Future<ProjectRiskListResponse> getProjectRisksByProjectId(
    String projectId, {
    int skip = 0,
    int take = 10,
  });

  Future<void> createProjectRisk(CreateProjectRiskRequest request);

  Future<void> createProjectRiskForProject({
    required String projectId,
    required ProjectRiskWriteRequest request,
  });

  Future<void> updateProjectRisk(ProjectRiskWriteRequest request);

  Future<void> deleteProjectRisk(String riskId);

  Future<List<ProjectDxItemDto>> getProjects();

  Future<List<AccountDxItemDto>> getAccounts();
}

class RiskRemoteDataSourceImpl implements RiskRemoteDataSource {
  @override
  Future<ProjectRiskListResponse> getProjectRisks({
    int skip = 0,
    int take = 10,
    String? searchText,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRiskListDx,
      query: DxListQuery.paged(
        skip: skip,
        take: take,
        searchText: searchText,
        searchFields: const [
          'title',
          'description',
          'contingencyPlan',
          'responsePlan',
        ],
      ),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project risk response');
    }
    return ProjectRiskListResponse.fromJson(body);
  }

  @override
  Future<ProjectRiskListResponse> getProjectRisksByProjectId(
    String projectId, {
    int skip = 0,
    int take = 10,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRiskListByProject(projectId),
      query: {
        'skip': skip,
        'take': take,
        'requireTotalCount': true,
      },
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project risk list response');
    }
    return ProjectRiskListResponse.fromJson(body);
  }

  @override
  Future<void> createProjectRisk(CreateProjectRiskRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.createProjectRisk,
      data: request.toFormData(),
    );
  }

  @override
  Future<void> createProjectRiskForProject({
    required String projectId,
    required ProjectRiskWriteRequest request,
  }) async {
    await DioHelper.postData(
      url: PmoEndpoints.createProjectRisk,
      query: {'projectId': projectId},
      data: request.toFormData(projectId: projectId),
    );
  }

  @override
  Future<void> updateProjectRisk(ProjectRiskWriteRequest request) async {
    await DioHelper.putData(
      url: PmoEndpoints.updateProjectRisk,
      data: request.toUpdateFormData(),
    );
  }

  @override
  Future<void> deleteProjectRisk(String riskId) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.deleteProjectRisk,
      data: FormData.fromMap({'key': riskId}),
    );
  }

  @override
  Future<List<ProjectDxItemDto>> getProjects() async {
    final response = await DioHelper.getData(url: PmoEndpoints.projectDxList);
    final body = response.data as Map<String, dynamic>;
    return parseProjectDxItems(body['data']);
  }

  @override
  Future<List<AccountDxItemDto>> getAccounts() async {
    final response = await DioHelper.getData(url: PmoEndpoints.accountListDx);
    final body = response.data as Map<String, dynamic>;
    return parseAccountDxItems(body['data']);
  }
}
