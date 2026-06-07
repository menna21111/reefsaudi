part of 'risk_management_cubit.dart';

sealed class RiskManagementState extends Equatable {
  const RiskManagementState();

  @override
  List<Object?> get props => [];
}

class RiskManagementInitial extends RiskManagementState {
  const RiskManagementInitial();
}

class RiskManagementLoading extends RiskManagementState {
  const RiskManagementLoading();
}

class RiskManagementLoaded extends RiskManagementState {
  final List<ProjectRiskDto> risks;
  final int totalCount;
  final int skip;
  final int take;
  final bool isLoadingMore;
  final bool isRefreshing;
  final List<ProjectDxItemDto> projects;
  final List<AccountDxItemDto> accounts;
  final bool isFormDataLoading;
  final bool isSubmitting;

  const RiskManagementLoaded({
    required this.risks,
    required this.totalCount,
    required this.skip,
    required this.take,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.projects = const [],
    this.accounts = const [],
    this.isFormDataLoading = false,
    this.isSubmitting = false,
  });

  bool get hasMore => risks.length < totalCount;

  RiskManagementLoaded copyWith({
    List<ProjectRiskDto>? risks,
    int? totalCount,
    int? skip,
    int? take,
    bool? isLoadingMore,
    bool? isRefreshing,
    List<ProjectDxItemDto>? projects,
    List<AccountDxItemDto>? accounts,
    bool? isFormDataLoading,
    bool? isSubmitting,
  }) {
    return RiskManagementLoaded(
      risks: risks ?? this.risks,
      totalCount: totalCount ?? this.totalCount,
      skip: skip ?? this.skip,
      take: take ?? this.take,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      projects: projects ?? this.projects,
      accounts: accounts ?? this.accounts,
      isFormDataLoading: isFormDataLoading ?? this.isFormDataLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        risks,
        totalCount,
        skip,
        take,
        isLoadingMore,
        isRefreshing,
        projects,
        accounts,
        isFormDataLoading,
        isSubmitting,
      ];
}

class RiskManagementError extends RiskManagementState {
  final String message;

  const RiskManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
