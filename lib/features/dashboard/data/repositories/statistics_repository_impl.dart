import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_data_source.dart';
import '../models/global_statistics_models.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final StatisticsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, GlobalStatisticsBundle>> loadStatistics({
    String? regionId,
    String? regionTitle,
    List<AreaProjectDto>? cachedAreas,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final hasRegion = regionId != null && regionId != 'null';

      final futures = <Future<dynamic>>[
        remoteDataSource.getGeneralStatistics(regionId: regionId),
        remoteDataSource.getExecutionSummary(regionId: regionId),
        if (cachedAreas == null) remoteDataSource.getAreaProjects(),
        if (hasRegion) remoteDataSource.getSectorProjects(regionId: regionId),
        if (hasRegion) remoteDataSource.getQcTechnical(regionId: regionId),
      ];

      final results = await Future.wait(futures);

      var index = 0;
      final general = results[index++] as GeneralStatisticsDto;
      final execution = results[index++] as ProjectExecutionSummaryDto;

      List<AreaProjectDto> areas;
      if (cachedAreas != null) {
        areas = cachedAreas;
      } else {
        areas = results[index++] as List<AreaProjectDto>;
      }

      List<SectorProjectDto> sectors = const [];
      List<GlobalQcCategoryDto> qcTechnical = const [];
      if (hasRegion) {
        sectors = results[index++] as List<SectorProjectDto>;
        qcTechnical = results[index++] as List<GlobalQcCategoryDto>;
      }

      return Right(
        GlobalStatisticsBundle(
          general: general,
          execution: execution,
          areas: areas,
          sectors: sectors,
          qcTechnical: qcTechnical,
          selectedRegionId: hasRegion ? regionId : null,
          selectedRegionTitle: hasRegion ? regionTitle : null,
        ),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
