part of 'employees_cubit.dart';

sealed class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object?> get props => [];
}

final class EmployeesInitial extends EmployeesState {
  const EmployeesInitial();
}

final class EmployeesLoading extends EmployeesState {
  const EmployeesLoading();
}

final class EmployeesLoaded extends EmployeesState {
  const EmployeesLoaded({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    this.searchText = '',
    this.isRefreshing = false,
    this.isPageLoading = false,
    this.isSubmitting = false,
  });

  final List<Employee> items;
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

  EmployeesLoaded copyWith({
    List<Employee>? items,
    int? totalCount,
    int? currentPage,
    int? pageSize,
    String? searchText,
    bool? isRefreshing,
    bool? isPageLoading,
    bool? isSubmitting,
  }) {
    return EmployeesLoaded(
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

final class EmployeesError extends EmployeesState {
  const EmployeesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
