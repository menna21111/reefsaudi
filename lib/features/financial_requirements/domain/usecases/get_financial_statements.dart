import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../entities/paginated_financial_requirements.dart';
import '../repositories/financial_requirements_repository.dart';

class GetFinancialStatementsParams {
  final int pageNumber;
  final int pageSize;

  const GetFinancialStatementsParams({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

class GetFinancialStatementsUseCase
    extends UseCase2<PaginatedFinancialRequirements, GetFinancialStatementsParams> {
  final FinancialRequirementsRepository repository;

  GetFinancialStatementsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedFinancialRequirements>> call(
    GetFinancialStatementsParams params,
  ) {
    return repository.getFinancialStatements(
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
    );
  }
}
