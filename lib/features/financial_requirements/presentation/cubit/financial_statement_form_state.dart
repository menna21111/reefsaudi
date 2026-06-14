part of 'financial_statement_form_cubit.dart';

sealed class FinancialStatementFormState {
  const FinancialStatementFormState();
}

class FinancialStatementFormInitial extends FinancialStatementFormState {
  const FinancialStatementFormInitial();
}

class FinancialStatementFormLoading extends FinancialStatementFormState {
  const FinancialStatementFormLoading();
}

class FinancialStatementFormLoaded extends FinancialStatementFormState {
  final FinancialStatementFormLookups lookups;
  final bool isSubmitting;
  final String? submitError;

  const FinancialStatementFormLoaded({
    required this.lookups,
    this.isSubmitting = false,
    this.submitError,
  });

  FinancialStatementFormLoaded copyWith({
    FinancialStatementFormLookups? lookups,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return FinancialStatementFormLoaded(
      lookups: lookups ?? this.lookups,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError:
          clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }
}

class FinancialStatementFormError extends FinancialStatementFormState {
  final String message;

  const FinancialStatementFormError(this.message);
}
