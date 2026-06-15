import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/create_financial_statement_request.dart';
import '../../domain/repositories/financial_requirements_repository.dart';

part 'financial_statement_form_state.dart';

class FinancialStatementFormCubit extends Cubit<FinancialStatementFormState> {
  FinancialStatementFormCubit({required this.repository})
      : super(const FinancialStatementFormInitial());

  final FinancialRequirementsRepository repository;

  Future<void> loadLookups() async {
    emit(const FinancialStatementFormLoading());

    final result = await repository.getFormLookups();
    result.fold(
      (failure) => emit(FinancialStatementFormError(failure.errMessage)),
      (lookups) => emit(FinancialStatementFormLoaded(lookups: lookups)),
    );
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
