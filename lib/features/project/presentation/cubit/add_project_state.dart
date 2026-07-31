import '../../../risk_management/data/models/project_risk_models.dart';

sealed class AddProjectState {}

class AddProjectInitial extends AddProjectState {}

class AddProjectLoading extends AddProjectState {}

class AddProjectLoaded extends AddProjectState {
  AddProjectLoaded({
    required this.contractors,
    required this.consultants,
    required this.accounts,
    this.isSubmitting = false,
  });

  final List<AccountDxItemDto> contractors;
  final List<AccountDxItemDto> consultants;
  final List<AccountDxItemDto> accounts;
  final bool isSubmitting;

  AddProjectLoaded copyWith({
    List<AccountDxItemDto>? contractors,
    List<AccountDxItemDto>? consultants,
    List<AccountDxItemDto>? accounts,
    bool? isSubmitting,
  }) {
    return AddProjectLoaded(
      contractors: contractors ?? this.contractors,
      consultants: consultants ?? this.consultants,
      accounts: accounts ?? this.accounts,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class AddProjectError extends AddProjectState {
  AddProjectError(this.message);

  final String message;
}
