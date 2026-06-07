import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../project/data/models/project_api_models.dart';
import '../models/project_risk_models.dart';

abstract class RiskRemoteDataSource {
  Future<ProjectRiskListResponse> getProjectRisks({
    int skip = 0,
    int take = 10,
  });

  Future<void> createProjectRisk(CreateProjectRiskRequest request);

  Future<List<ProjectDxItemDto>> getProjects();

  Future<List<AccountDxItemDto>> getAccounts();
}

class RiskRemoteDataSourceImpl implements RiskRemoteDataSource {
  @override
  Future<ProjectRiskListResponse> getProjectRisks({
    int skip = 0,
    int take = 10,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectRiskListDx,
      query: {
        'skip': skip,
        'take': take,
        'requireTotalCount': true,
      },
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected project risk response');
    }
    return ProjectRiskListResponse.fromJson(body);
  }

  @override
  Future<void> createProjectRisk(CreateProjectRiskRequest request) async {
    await DioHelper.postData(
      url: PmoEndpoints.createProjectRisk,
      data: request.toJson(),
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
