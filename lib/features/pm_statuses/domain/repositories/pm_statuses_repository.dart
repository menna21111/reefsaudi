import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/pm_status.dart';

abstract class PmStatusesRepository {
  Future<Either<Failure, PmStatusListResult>> getPmStatuses({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createPmStatus(PmStatusWriteRequest request);

  Future<Either<Failure, void>> updatePmStatus({
    required String id,
    required PmStatusWriteRequest request,
  });

  Future<Either<Failure, void>> deletePmStatus(String id);
}
