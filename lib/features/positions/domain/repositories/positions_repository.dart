import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/position.dart';

abstract class PositionsRepository {
  Future<Either<Failure, PositionListResult>> getPositions({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createPosition(PositionWriteRequest request);

  Future<Either<Failure, void>> updatePosition({
    required String id,
    required PositionWriteRequest request,
  });

  Future<Either<Failure, void>> deletePosition(String id);
}
