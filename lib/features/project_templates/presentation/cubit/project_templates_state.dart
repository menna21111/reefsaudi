part of 'project_templates_cubit.dart';

sealed class ProjectTemplatesState extends Equatable {
  const ProjectTemplatesState();

  @override
  List<Object?> get props => [];
}

final class ProjectTemplatesInitial extends ProjectTemplatesState {
  const ProjectTemplatesInitial();
}

final class ProjectTemplatesLoading extends ProjectTemplatesState {
  const ProjectTemplatesLoading();
}

final class ProjectTemplatesLoaded extends ProjectTemplatesState {
  const ProjectTemplatesLoaded({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.searchText,
    this.isRefreshing = false,
    this.isPageLoading = false,
    this.isSubmitting = false,
  });

  final List<ProjectTemplate> items;
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

  ProjectTemplatesLoaded copyWith({
    List<ProjectTemplate>? items,
    int? totalCount,
    int? currentPage,
    int? pageSize,
    String? searchText,
    bool? isRefreshing,
    bool? isPageLoading,
    bool? isSubmitting,
  }) {
    return ProjectTemplatesLoaded(
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

final class ProjectTemplatesError extends ProjectTemplatesState {
  const ProjectTemplatesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
