import 'package:equatable/equatable.dart';

import '../../data/models/dashboard_project_filters.dart';
import '../../data/models/project_search_response_model.dart';

enum DashboardStatsStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  const DashboardState({
    this.statsStatus = DashboardStatsStatus.initial,
    this.stats,
    this.statsError,
    this.query,
    this.isStatsRefreshing = false,
    this.isLoadingMore = false,
    this.filters = const DashboardProjectFilters(),
    this.draftFilters = const DashboardProjectFilters(),
    this.filterOptionsLoading = false,
    this.brandsOptions = const [],
    this.productionLinesOptions = const [],
    this.productsOptions = const [],
    this.sizesOptions = const [],
  });

  const DashboardState.initial() : this();

  final DashboardStatsStatus statsStatus;
  final DashboardStats? stats;
  final String? statsError;
  final String? query;
  final bool isStatsRefreshing;
  final bool isLoadingMore;
  final DashboardProjectFilters filters;
  final DashboardProjectFilters draftFilters;
  final bool filterOptionsLoading;
  final List<FilterStringOption> brandsOptions;
  final List<FilterStringOption> productionLinesOptions;
  final List<FilterStringOption> productsOptions;
  final List<FilterStringOption> sizesOptions;

  bool get isStatsLoading =>
      statsStatus == DashboardStatsStatus.loading ||
      statsStatus == DashboardStatsStatus.initial;

  bool get isStatsLoaded => statsStatus == DashboardStatsStatus.loaded;

  bool get hasStatsError => statsStatus == DashboardStatsStatus.error;

  bool get hasPendingFilterChanges => draftFilters != filters;

  DashboardState copyWith({
    DashboardStatsStatus? statsStatus,
    DashboardStats? stats,
    String? statsError,
    String? query,
    bool? isStatsRefreshing,
    bool? isLoadingMore,
    DashboardProjectFilters? filters,
    DashboardProjectFilters? draftFilters,
    bool? filterOptionsLoading,
    List<FilterStringOption>? brandsOptions,
    List<FilterStringOption>? productionLinesOptions,
    List<FilterStringOption>? productsOptions,
    List<FilterStringOption>? sizesOptions,
    bool clearStats = false,
    bool clearStatsError = false,
    bool clearQuery = false,
  }) {
    return DashboardState(
      statsStatus: statsStatus ?? this.statsStatus,
      stats: clearStats ? null : (stats ?? this.stats),
      statsError: clearStatsError ? null : (statsError ?? this.statsError),
      query: clearQuery ? null : (query ?? this.query),
      isStatsRefreshing: isStatsRefreshing ?? this.isStatsRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      filters: filters ?? this.filters,
      draftFilters: draftFilters ?? this.draftFilters,
      filterOptionsLoading: filterOptionsLoading ?? this.filterOptionsLoading,
      brandsOptions: brandsOptions ?? this.brandsOptions,
      productionLinesOptions:
          productionLinesOptions ?? this.productionLinesOptions,
      productsOptions: productsOptions ?? this.productsOptions,
      sizesOptions: sizesOptions ?? this.sizesOptions,
    );
  }

  @override
  List<Object?> get props => [
        statsStatus,
        stats,
        statsError,
        query,
        isStatsRefreshing,
        isLoadingMore,
        filters,
        draftFilters,
        filterOptionsLoading,
        brandsOptions,
        productionLinesOptions,
        productsOptions,
        sizesOptions,
      ];
}

class FilterStringOption extends Equatable {
  const FilterStringOption({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
