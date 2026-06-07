import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/global_statistics_models.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, GlobalStatisticsBundle>> loadStatistics({
    String? regionId,
    String? regionTitle,
    List<AreaProjectDto>? cachedAreas,
  });
}
