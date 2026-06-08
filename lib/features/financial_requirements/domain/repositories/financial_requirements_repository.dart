import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/paginated_financial_requirements.dart';

abstract class FinancialRequirementsRepository {
  Future<Either<Failure, PaginatedFinancialRequirements>> getFinancialStatements({
    required int pageNumber,
    required int pageSize,
  });
}
