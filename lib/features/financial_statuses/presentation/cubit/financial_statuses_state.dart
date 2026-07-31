part of 'financial_statuses_cubit.dart';

sealed class FinancialStatusesState extends Equatable {
  const FinancialStatusesState();

  @override
  List<Object?> get props => [];
}

final class FinancialStatusesInitial extends FinancialStatusesState {
  const FinancialStatusesInitial();
}

final class FinancialStatusesLoading extends FinancialStatusesState {
  const FinancialStatusesLoading();
}

final class FinancialStatusesLoaded extends FinancialStatusesState {
  const FinancialStatusesLoaded({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.searchText,
    this.isRefreshing = false,
    this.isPageLoading = false,
    this.isSubmitting = false,
  });

  final List<FinancialStatusItem> items;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final String searchText;
  final bool isRefreshing;
  final bool isPageLoading;
  final bool isSubmitting;

  int get totalPages =>
      totalCount == 0 ? 1 : ((totalCount - 1) ~/ pageSize) + 1;

  bool get hasPreviousPage => currentPage > 1;
  bool get hasNextPage => currentPage < totalPages;

  FinancialStatusesLoaded copyWith({
    List<FinancialStatusItem>? items,
    int? totalCount,
    int? currentPage,
    int? pageSize,
    String? searchText,
    bool? isRefreshing,
    bool? isPageLoading,
    bool? isSubmitting,
  }) {
    return FinancialStatusesLoaded(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      searchText: searchText ?? this.searchText,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        items,
        totalCount,
        currentPage,
        pageSize,
        searchText,
        isRefreshing,
        isPageLoading,
        isSubmitting,
      ];
}

final class FinancialStatusesError extends FinancialStatusesState {
  const FinancialStatusesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
