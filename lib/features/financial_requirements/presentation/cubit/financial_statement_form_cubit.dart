import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../project/data/models/project_api_models.dart';
import '../../data/models/create_financial_statement_request.dart';
import '../../data/models/dx_title_item_dto.dart';
import '../../domain/repositories/financial_requirements_repository.dart';

part 'financial_statement_form_state.dart';

class FinancialStatementFormCubit extends Cubit<FinancialStatementFormState> {
  FinancialStatementFormCubit({required this.repository})
      : super(const FinancialStatementFormLoaded());

  final FinancialRequirementsRepository repository;

  Future<List<ProjectDxItemDto>> fetchProjects() async {
    final result = await repository.getProjectsDx();
    return result.fold((_) => <ProjectDxItemDto>[], (items) => items);
  }

  Future<List<DxTitleItemDto>> fetchFinancialStatuses() async {
    final result = await repository.getFinancialStatusesDx();
    return result.fold((_) => <DxTitleItemDto>[], (items) => items);
  }

  Future<List<DxTitleItemDto>> fetchPmStatuses() async {
    final result = await repository.getPmStatusesDx();
    return result.fold((_) => <DxTitleItemDto>[], (items) => items);
  }

  /// Returns `null` on success, or an error message key/string on failure.
  Future<String?> submitCreate(CreateFinancialStatementRequest request) async {
    final current = state;
    if (current is! FinancialStatementFormLoaded || current.isSubmitting) {
      return 'something_went_wrong';
    }

    emit(current.copyWith(isSubmitting: true, clearSubmitError: true));

    final result = await repository.createFinancialStatement(request);

    final latest = state;
    if (latest is! FinancialStatementFormLoaded) return 'something_went_wrong';

    return result.fold(
      (failure) {
        emit(latest.copyWith(
          isSubmitting: false,
          submitError: failure.errMessage,
        ));
        return failure.errMessage;
      },
      (_) {
        emit(latest.copyWith(isSubmitting: false, clearSubmitError: true));
        return null;
      },
    );
  }
}
