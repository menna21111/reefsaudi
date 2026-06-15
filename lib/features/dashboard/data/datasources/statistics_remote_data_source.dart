import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/global_statistics_models.dart';

abstract class StatisticsRemoteDataSource {
  Future<GeneralStatisticsDto> getGeneralStatistics({String? regionId});

  Future<ProjectExecutionSummaryDto> getExecutionSummary({String? regionId});

  Future<List<AreaProjectDto>> getAreaProjects();

  Future<List<SectorProjectDto>> getSectorProjects({String? regionId});

  Future<List<GlobalQcCategoryDto>> getQcTechnical({String? regionId});

  Future<List<StatisticsKeyValueDto>> getProjectStatusCounts({
    String? regionId,
  });

  Future<List<StatisticsKeyValueDto>> getCountByType({String? regionId});
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  @override
  Future<GeneralStatisticsDto> getGeneralStatistics({String? regionId}) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStatisticsGeneral,
      query: PmoEndpoints.regionQuery(regionId),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected general statistics response');
    }
    return GeneralStatisticsDto.fromJson(body);
  }

  @override
  Future<ProjectExecutionSummaryDto> getExecutionSummary({
    String? regionId,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.financialProjectExecutionSummary,
      query: PmoEndpoints.regionQuery(regionId),
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected execution summary response');
    }
    return ProjectExecutionSummaryDto.fromJson(body);
  }

  @override
  Future<List<AreaProjectDto>> getAreaProjects() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStatisticsAreaProject,
    );
    return parseAreaProjects(response.data);
  }

  @override
  Future<List<SectorProjectDto>> getSectorProjects({String? regionId}) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStatisticsSectorProjects,
      query: PmoEndpoints.regionQuery(regionId),
    );
    return parseSectorProjects(response.data);
  }

  @override
  Future<List<GlobalQcCategoryDto>> getQcTechnical({String? regionId}) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStatisticsQcTechnical,
      query: PmoEndpoints.regionQuery(regionId),
    );
    return parseGlobalQcCategories(response.data);
  }

  @override
  Future<List<StatisticsKeyValueDto>> getProjectStatusCounts({
    String? regionId,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStatisticsProjectStatusCounts,
      query: PmoEndpoints.regionQuery(regionId),
    );
    return parseStatisticsKeyValues(response.data);
  }

  @override
  Future<List<StatisticsKeyValueDto>> getCountByType({String? regionId}) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.projectStatisticsCountByType,
      query: PmoEndpoints.regionQuery(regionId),
    );
    return parseStatisticsKeyValues(response.data);
  }
}
