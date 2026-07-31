import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_data_source.dart';
import '../models/global_statistics_models.dart';
import '../models/portfolio_overview_models.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final StatisticsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GeneralStatisticsDto>> getGeneralStatistics({
    String? regionId,
  }) =>
      _guard(() => remoteDataSource.getGeneralStatistics(regionId: regionId));

  @override
  Future<Either<Failure, ProjectExecutionSummaryDto>> getExecutionSummary({
    String? regionId,
  }) =>
      _guard(() => remoteDataSource.getExecutionSummary(regionId: regionId));

  @override
  Future<Either<Failure, List<AreaProjectDto>>> getAreaProjects() =>
      _guard(remoteDataSource.getAreaProjects);

  @override
  Future<Either<Failure, List<SectorProjectDto>>> getSectorProjects({
    String? regionId,
  }) =>
      _guard(() => remoteDataSource.getSectorProjects(regionId: regionId));

  @override
  Future<Either<Failure, List<GlobalQcCategoryDto>>> getQcTechnical({
    String? regionId,
  }) =>
      _guard(() => remoteDataSource.getQcTechnical(regionId: regionId));

  @override
  Future<Either<Failure, List<StatisticsKeyValueDto>>> getProjectStatusCounts({
    String? regionId,
  }) =>
      _guard(
        () => remoteDataSource.getProjectStatusCounts(regionId: regionId),
      );

  @override
  Future<Either<Failure, List<StatisticsKeyValueDto>>> getCountByType({
    String? regionId,
  }) =>
      _guard(() => remoteDataSource.getCountByType(regionId: regionId));

  @override
  Future<Either<Failure, PortfolioOverviewBundle>> loadPortfolioOverview({
    String? brandId,
    String? brandTitle,
    List<BrandDto>? cachedBrands,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      final hasBrand = brandId != null && brandId.isNotEmpty;

      final futures = <Future<dynamic>>[
        remoteDataSource.getProjectsFinancialSectors(brandId: brandId),
        remoteDataSource.getProjectsStatusCountsSectors(brandId: brandId),
        remoteDataSource.getFinancialStatementProjects(brandId: brandId),
        if (cachedBrands == null) remoteDataSource.getBrands(),
      ];

      final results = await Future.wait(futures);

      var index = 0;
      final sectors = results[index++] as ProjectsFinancialSectorsDto;
      final statusCounts = results[index++] as ProjectStatusCountsDto;
      final financial = results[index++] as FinancialStatementProjectsDto;

      List<BrandDto> brands;
      if (cachedBrands != null) {
        brands = cachedBrands;
      } else {
        final brandsPage = results[index++] as BrandsPageDto;
        brands = brandsPage.items;
      }

      return Right(
        PortfolioOverviewBundle(
          sectors: sectors,
          statusCounts: statusCounts,
          financial: financial,
          brands: brands,
          selectedBrandId: hasBrand ? brandId : null,
          selectedBrandTitle: hasBrand ? brandTitle : null,
        ),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
