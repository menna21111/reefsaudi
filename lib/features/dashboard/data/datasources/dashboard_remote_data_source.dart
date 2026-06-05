import 'package:dio/dio.dart';

import '../../../../core/network/pmo_endpoints.dart';
import '../models/project_search_response_model.dart';

abstract class DashboardRemoteDataSource {
  Future<ProjectSearchResponseModel> searchProjects({int pageSize});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<ProjectSearchResponseModel> searchProjects({
    int pageSize = 100,
  }) async {
    final response = await dio.post(
      PmoEndpoints.projectSearch,
      data: {
        'page': 1,
        'pageSize': pageSize,
      },
    );

    final body = response.data;
    if (body is Map<String, dynamic>) {
      return ProjectSearchResponseModel.fromJson(body);
    }
    throw const FormatException('Unexpected project search response');
  }
}
