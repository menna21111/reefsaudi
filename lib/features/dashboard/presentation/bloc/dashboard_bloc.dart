import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/models/project_search_request.dart';
import '../../domain/entities/project.dart';
import '../../domain/usecases/get_projects.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required this.getProjectsUseCase,
    required this.getDashboardStatsUseCase,
  }) : super(DashboardInitial()) {
    _initPaging();
    on<LoadDashboardStats>(_onLoadStats);
    on<RefreshDashboard>(_onRefresh);
    on<FilterProjects>(_onFilter);
    on<SearchProjects>(_onSearch);
  }

  static const int pageSize = 10;

  final GetProjectsUseCase getProjectsUseCase;
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  final PagingController<int, Project> pagingController =
      PagingController(firstPageKey: 1);

  String? _query;
  String _selectedStatus = 'all';
  List<int> _projectStatus = [];
  bool _isLoadingMore = false;

  void _initPaging() {
    pagingController.addPageRequestListener(_fetchProjectsPage);
  }

  ProjectSearchRequest _baseRequest() {
    return ProjectSearchRequest(
      query: _query,
      projectStatus: _projectStatus,
      projectTypes: const [0],
    );
  }

  List<int> _statusFilterToApi(String status) {
    switch (status) {
      case 'in_progress':
        return const [0];
      case 'finished':
        return const [5];
      case 'stalled':
        return const [1, 3, 6];
      default:
        return const [];
    }
  }

  Future<void> _onLoadStats(
    LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardStatsLoading());

    final result = await getDashboardStatsUseCase(_baseRequest());
    result.fold(
      (failure) => emit(DashboardStatsError(failure.errMessage)),
      (stats) => emit(
        DashboardStatsLoaded(
          stats: stats,
          selectedStatus: _selectedStatus,
          query: _query,
        ),
      ),
    );
  }

  Future<void> _onRefresh(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    add(const LoadDashboardStats());
    pagingController.refresh();
  }

  Future<void> _onFilter(
    FilterProjects event,
    Emitter<DashboardState> emit,
  ) async {
    _selectedStatus = event.status;
    _projectStatus = _statusFilterToApi(event.status);

    final current = state;
    if (current is DashboardStatsLoaded) {
      emit(current.copyWith(selectedStatus: _selectedStatus));
    }

    add(const LoadDashboardStats());
    pagingController.refresh();
  }

  Future<void> _onSearch(
    SearchProjects event,
    Emitter<DashboardState> emit,
  ) async {
    _query = event.query?.trim().isEmpty ?? true ? null : event.query?.trim();

    final current = state;
    if (current is DashboardStatsLoaded) {
      emit(current.copyWith(query: _query));
    }

    add(const LoadDashboardStats());
    pagingController.refresh();
  }

  bool get isLoadingMore => _isLoadingMore;

  bool get canLoadMore => pagingController.nextPageKey != null;

  Future<void> loadMoreIfAvailable() async {
    if (_isLoadingMore) return;
    final nextKey = pagingController.nextPageKey;
    if (nextKey == null) return;

    _isLoadingMore = true;
    try {
      await _fetchProjectsPage(nextKey);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> _fetchProjectsPage(int pageKey) async {
    final request = _baseRequest().copyWith(
        page: pageKey,
        size: pageSize,
        includeAggs: false,
        aggsOnly: false,
      );

      final result = await getProjectsUseCase(request);

    result.fold(
      (failure) {
        pagingController.error = failure.errMessage;
      },
      (data) {
        final newItems = data.projects;
        final isLastPage =
            pageKey * pageSize >= data.total || newItems.length < pageSize;

        final existingIds =
            pagingController.itemList?.map((project) => project.id).toSet() ??
                {};
        final filteredItems = newItems
            .where((project) => !existingIds.contains(project.id))
            .toList();

        if (isLastPage) {
          pagingController.appendLastPage(filteredItems);
        } else {
          pagingController.appendPage(filteredItems, pageKey + 1);
        }
      },
    );
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
