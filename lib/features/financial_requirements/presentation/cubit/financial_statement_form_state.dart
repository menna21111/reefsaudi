part of 'financial_statement_form_cubit.dart';

sealed class FinancialStatementFormState {
  const FinancialStatementFormState();
}

class FinancialStatementFormLoaded extends FinancialStatementFormState {
  final bool isSubmitting;
  final String? submitError;

  const FinancialStatementFormLoaded({
    this.isSubmitting = false,
    this.submitError,
  });

  FinancialStatementFormLoaded copyWith({
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return FinancialStatementFormLoaded(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError:
          clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }
}
