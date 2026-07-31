import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../data/models/create_financial_statement_request.dart';
import '../../data/models/dx_title_item_dto.dart';
import '../entities/financial_statement_summary.dart';
import '../entities/paginated_financial_requirements.dart';

class FinancialStatementFormLookups {
  final List<ProjectDxItemDto> projects;
  final List<DxTitleItemDto> financialStatuses;
  final List<DxTitleItemDto> pmStatuses;

  const FinancialStatementFormLookups({
    required this.projects,
    required this.financialStatuses,
    required this.pmStatuses,
  });
}

abstract class FinancialRequirementsRepository {
  Future<Either<Failure, PaginatedFinancialRequirements>>
  getFinancialStatements({required int pageNumber, required int pageSize});

  Future<Either<Failure, FinancialStatementSummary>> getStatementCount();

  Future<Either<Failure, FinancialStatementSummary>> getStatementSum();

  Future<Either<Failure, FinancialStatementFormLookups>> getFormLookups();

  Future<Either<Failure, List<ProjectDxItemDto>>> getProjectsDx();

  Future<Either<Failure, List<DxTitleItemDto>>> getFinancialStatusesDx();

  Future<Either<Failure, List<DxTitleItemDto>>> getPmStatusesDx();

  Future<Either<Failure, void>> createFinancialStatement(
    CreateFinancialStatementRequest request,
  );

  Future<Either<Failure, void>> deleteFinancialStatement(String id);
}
