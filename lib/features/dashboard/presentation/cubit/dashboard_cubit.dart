import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../project/data/datasources/edit_project_remote_data_source.dart';
import '../../../project/data/models/project_edit_models.dart';
import '../../data/models/dashboard_project_filters.dart';
import '../../data/models/project_search_request.dart';
import '../../domain/entities/project.dart';
import '../../domain/usecases/get_projects.dart';
import '../constants/dashboard_filter_options.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required this.getProjectsUseCase,
    required this.getDashboardStatsUseCase,
    required this.filterDataSource,
  }) : super(const DashboardState.initial()) {
    _initPaging();
  }

  static const int pageSize = 10;

  final GetProjectsUseCase getProjectsUseCase;
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final EditProjectRemoteDataSource filterDataSource;

  final PagingController<int, Project> pagingController =
      PagingController(firstPageKey: 1);

  String? _query;
  DashboardProjectFilters _filters = const DashboardProjectFilters();
  DashboardProjectFilters _draftFilters = const DashboardProjectFilters();
  bool _filterOptionsLoaded = false;
  bool _isLoadingMore = false;
  bool _manualFirstPageFetch = false;
  int _fetchGeneration = 0;
  int _totalProjects = 0;

  void _initPaging() {
    pagingController.addPageRequestListener((pageKey) {
      if (_manualFirstPageFetch && pageKey == pagingController.firstPageKey) {
        return;
      }
      _fetchProjectsPage(pageKey);
    });
  }

  ProjectSearchRequest _baseRequest() {
    return ProjectSearchRequest(
      query: _query,
      brands: _filters.brands,
      productionLines: _filters.productionLines,
      products: _filters.products,
      sizes: _filters.sizes,
      projectStatus: _filters.projectStatus,
      projectTypes: _filters.projectTypes.isEmpty
          ? const [0]
          : _filters.projectTypes,
    );
  }

  Future<void> loadFilterOptions() async {
    if (_filterOptionsLoaded || state.filterOptionsLoading) return;

    emit(state.copyWith(filterOptionsLoading: true));

    try {
      final brands = await filterDataSource.getBrands();
      final productionLines = await filterDataSource.getProductionLines();
      final products = await filterDataSource.getProducts();
      final sizes = await filterDataSource.getSizes();

      _filterOptionsLoaded = true;
      emit(
        state.copyWith(
          filterOptionsLoading: false,
          brandsOptions: _mapOptions(brands),
          productionLinesOptions: _mapOptions(productionLines),
          productsOptions: _mapOptions(products),
          sizesOptions: _mapOptions(sizes),
        ),
      );
    } catch (_) {
      emit(state.copyWith(filterOptionsLoading: false));
    }
  }

  List<FilterStringOption> _mapOptions(List<DxListItemDto> items) {
    return items
        .map(
          (item) => FilterStringOption(id: item.id, title: item.title),
        )
        .toList();
  }

  void setStringFiltersForCategory(
    ProjectFilterCategory category,
    List<String> ids,
  ) {
    _draftFilters = _setStringInFilters(_draftFilters, category, ids);
    emit(state.copyWith(draftFilters: _draftFilters));
  }

  void setIntFiltersForCategory(
    ProjectFilterCategory category,
    List<int> values,
  ) {
    _draftFilters = _setIntInFilters(_draftFilters, category, values);
    emit(state.copyWith(draftFilters: _draftFilters));
  }

  DashboardProjectFilters _setStringInFilters(
    DashboardProjectFilters filters,
    ProjectFilterCategory category,
    List<String> ids,
  ) {
    switch (category) {
      case ProjectFilterCategory.brands:
        return filters.copyWith(brands: ids);
      case ProjectFilterCategory.productionLines:
        return filters.copyWith(productionLines: ids);
      case ProjectFilterCategory.products:
        return filters.copyWith(products: ids);
      case ProjectFilterCategory.sizes:
        return filters.copyWith(sizes: ids);
      default:
        return filters;
    }
  }

  DashboardProjectFilters _setIntInFilters(
    DashboardProjectFilters filters,
    ProjectFilterCategory category,
    List<int> values,
  ) {
    switch (category) {
      case ProjectFilterCategory.projectStatus:
        return filters.copyWith(projectStatus: values);
      case ProjectFilterCategory.projectTypes:
        return filters.copyWith(projectTypes: values);
      default:
        return filters;
    }
  }

  void clearDraftFilters() {
    _draftFilters = const DashboardProjectFilters();
    emit(state.copyWith(draftFilters: _draftFilters));
  }

  Future<void> _applyFilters() async {
    _fetchGeneration++;

    if (state.isStatsLoaded) {
      emit(state.copyWith(isStatsRefreshing: true, clearStatsError: true));
    }

    _manualFirstPageFetch = true;
    try {
      await _fetchProjectsPage(pagingController.firstPageKey);
    } finally {
      _manualFirstPageFetch = false;
    }

    loadStats();
  }

  Future<void> loadStats() async {
    final current = state;
    final hasExistingStats = current.isStatsLoaded;

    if (hasExistingStats) {
      emit(current.copyWith(isStatsRefreshing: true, clearStatsError: true));
    } else {
      emit(
        current.copyWith(
          statsStatus: DashboardStatsStatus.loading,
          clearStatsError: true,
        ),
      );
    }

    final result = await getDashboardStatsUseCase(_baseRequest());
    result.fold(
      (failure) {
        if (hasExistingStats) {
          emit(state.copyWith(isStatsRefreshing: false));
        } else {
          emit(
            state.copyWith(
              statsStatus: DashboardStatsStatus.error,
              statsError: failure.errMessage,
            ),
          );
        }
      },
      (stats) => emit(
        state.copyWith(
          statsStatus: DashboardStatsStatus.loaded,
          stats: stats,
          query: _query,
          filters: _filters,
          draftFilters: _draftFilters,
          isStatsRefreshing: false,
          clearStatsError: true,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    await _applyFilters();
  }

  Future<void> submitSearch(String? query) async {
    _query = query?.trim().isEmpty ?? true ? null : query?.trim();
    _filters = _draftFilters;

    emit(
      state.copyWith(
        query: _query,
        filters: _filters,
        draftFilters: _draftFilters,
        clearQuery: _query == null,
      ),
    );
    await _applyFilters();
  }

  Future<void> applyFilters() async {
    _filters = _draftFilters;
    emit(
      state.copyWith(
        filters: _filters,
        draftFilters: _draftFilters,
      ),
    );
    await _applyFilters();
  }

  bool get isLoadingMore => _isLoadingMore;

  bool get hasCachedProjects {
    final items = pagingController.itemList;
    return items != null && items.isNotEmpty;
  }

  /// Loads projects/stats only when nothing is cached yet (e.g. reopening from drawer).
  Future<void> ensureInitialLoad() async {
    if (!state.isStatsLoaded && !state.isStatsLoading) {
      loadStats();
    }
    if (hasCachedProjects || pagingController.error != null) return;

    _manualFirstPageFetch = true;
    try {
      await _fetchProjectsPage(pagingController.firstPageKey);
    } finally {
      _manualFirstPageFetch = false;
    }
  }

  bool get canLoadMore {
    final nextKey = pagingController.nextPageKey;
    if (nextKey == null) return false;
    return (nextKey - 1) * pageSize < _totalProjects;
  }

  Future<void> loadMoreIfAvailable() async {
    if (_isLoadingMore) return;
    final nextKey = pagingController.nextPageKey;
    if (nextKey == null) return;
    if ((nextKey - 1) * pageSize >= _totalProjects) return;

    _isLoadingMore = true;
    emit(state.copyWith(isLoadingMore: true));
    try {
      await _fetchProjectsPage(nextKey);
    } finally {
      _isLoadingMore = false;
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _fetchProjectsPage(int pageKey) async {
    final generation = _fetchGeneration;

    final request = _baseRequest().copyWith(
      page: pageKey,
      size: pageSize,
      includeAggs: false,
      aggsOnly: false,
    );

    final result = await getProjectsUseCase(request);

    if (generation != _fetchGeneration) return;

    result.fold(
      (failure) {
        if (generation != _fetchGeneration) return;
        pagingController.error = failure.errMessage;
      },
      (data) {
        if (generation != _fetchGeneration) return;

        _totalProjects = data.total;
        final newItems = data.projects;
        final isLastPage =
            newItems.isEmpty || pageKey * pageSize >= data.total;

        if (pageKey == pagingController.firstPageKey) {
          // Replace first page atomically — avoids empty flash on iPad/tablet.
          pagingController.itemList = newItems;
          pagingController.nextPageKey = isLastPage ? null : pageKey + 1;
          return;
        }

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
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
