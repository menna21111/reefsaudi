import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/region.dart';

abstract class RegionsRepository {
  Future<Either<Failure, RegionListResult>> getRegions({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createRegion(RegionWriteRequest request);

  Future<Either<Failure, void>> updateRegion({
    required String id,
    required RegionWriteRequest request,
  });

  Future<Either<Failure, void>> deleteRegion(String id);
}
