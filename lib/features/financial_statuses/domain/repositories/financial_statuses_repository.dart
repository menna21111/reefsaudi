import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/financial_status.dart';

abstract class FinancialStatusesRepository {
  Future<Either<Failure, FinancialStatusListResult>> getFinancialStatuses({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createFinancialStatus(
    FinancialStatusWriteRequest request,
  );

  Future<Either<Failure, void>> updateFinancialStatus({
    required String id,
    required FinancialStatusWriteRequest request,
  });

  Future<Either<Failure, void>> deleteFinancialStatus(String id);
}
