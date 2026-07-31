import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/global_statistics_models.dart';
import '../../data/models/portfolio_overview_models.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, GeneralStatisticsDto>> getGeneralStatistics({
    String? regionId,
  });

  Future<Either<Failure, ProjectExecutionSummaryDto>> getExecutionSummary({
    String? regionId,
  });

  Future<Either<Failure, List<AreaProjectDto>>> getAreaProjects();

  Future<Either<Failure, List<SectorProjectDto>>> getSectorProjects({
    String? regionId,
  });

  Future<Either<Failure, List<GlobalQcCategoryDto>>> getQcTechnical({
    String? regionId,
  });

  Future<Either<Failure, List<StatisticsKeyValueDto>>> getProjectStatusCounts({
    String? regionId,
  });

  Future<Either<Failure, List<StatisticsKeyValueDto>>> getCountByType({
    String? regionId,
  });

  Future<Either<Failure, PortfolioOverviewBundle>> loadPortfolioOverview({
    String? brandId,
    String? brandTitle,
    List<BrandDto>? cachedBrands,
  });
}
