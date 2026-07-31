import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/sector.dart';

abstract class SectorsRepository {
  Future<Either<Failure, SectorListResult>> getSectors({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createSector(SectorWriteRequest request);

  Future<Either<Failure, void>> updateSector({
    required String id,
    required SectorWriteRequest request,
  });

  Future<Either<Failure, void>> deleteSector(String id);
}
