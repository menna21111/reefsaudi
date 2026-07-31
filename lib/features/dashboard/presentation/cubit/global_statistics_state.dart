part of 'global_statistics_cubit.dart';

sealed class GlobalStatisticsState extends Equatable {
  const GlobalStatisticsState();

  @override
  List<Object?> get props => [];
}

class GlobalStatisticsInitial extends GlobalStatisticsState {
  const GlobalStatisticsInitial();
}

class GlobalStatisticsLoading extends GlobalStatisticsState {
  const GlobalStatisticsLoading();
}

class StatisticsSection<T> extends Equatable {
  const StatisticsSection({
    this.isLoading = false,
    this.data,
    this.error,
  });

  const StatisticsSection.loading() : this(isLoading: true);

  const StatisticsSection.success(T data) : this(data: data);

  const StatisticsSection.failure(String error) : this(error: error);

  final bool isLoading;
  final T? data;
  final String? error;

  bool get hasData => data != null;

  StatisticsSection<T> copyWith({
    bool? isLoading,
    T? data,
    String? error,
    bool clearError = false,
    bool clearData = false,
  }) {
    return StatisticsSection<T>(
      isLoading: isLoading ?? this.isLoading,
      data: clearData ? null : (data ?? this.data),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [isLoading, data, error];
}

class GlobalStatisticsLoaded extends GlobalStatisticsState {
  final StatisticsSection<GeneralStatisticsDto> general;
  final StatisticsSection<ProjectExecutionSummaryDto> execution;
  final StatisticsSection<List<AreaProjectDto>> areas;
  final StatisticsSection<List<SectorProjectDto>> sectors;
  final StatisticsSection<List<GlobalQcCategoryDto>> qcTechnical;
  final StatisticsSection<List<StatisticsKeyValueDto>> projectStatusCounts;
  final StatisticsSection<List<StatisticsKeyValueDto>> countByType;
  final String? selectedRegionId;
  final String? selectedRegionTitle;
  final String? selectedRegionCode;
  final bool isRefreshing;

  const GlobalStatisticsLoaded({
    this.general = const StatisticsSection.loading(),
    this.execution = const StatisticsSection.loading(),
    this.areas = const StatisticsSection.loading(),
    this.sectors = const StatisticsSection.loading(),
    this.qcTechnical = const StatisticsSection.loading(),
    this.projectStatusCounts = const StatisticsSection.loading(),
    this.countByType = const StatisticsSection.loading(),
    this.selectedRegionId,
    this.selectedRegionTitle,
    this.selectedRegionCode,
    this.isRefreshing = false,
  });

  GlobalStatisticsLoaded copyWith({
    StatisticsSection<GeneralStatisticsDto>? general,
    StatisticsSection<ProjectExecutionSummaryDto>? execution,
    StatisticsSection<List<AreaProjectDto>>? areas,
    StatisticsSection<List<SectorProjectDto>>? sectors,
    StatisticsSection<List<GlobalQcCategoryDto>>? qcTechnical,
    StatisticsSection<List<StatisticsKeyValueDto>>? projectStatusCounts,
    StatisticsSection<List<StatisticsKeyValueDto>>? countByType,
    String? selectedRegionId,
    String? selectedRegionTitle,
    String? selectedRegionCode,
    bool? isRefreshing,
    bool clearRegion = false,
  }) {
    return GlobalStatisticsLoaded(
      general: general ?? this.general,
      execution: execution ?? this.execution,
      areas: areas ?? this.areas,
      sectors: sectors ?? this.sectors,
      qcTechnical: qcTechnical ?? this.qcTechnical,
      projectStatusCounts: projectStatusCounts ?? this.projectStatusCounts,
      countByType: countByType ?? this.countByType,
      selectedRegionId:
          clearRegion ? null : (selectedRegionId ?? this.selectedRegionId),
      selectedRegionTitle: clearRegion
          ? null
          : (selectedRegionTitle ?? this.selectedRegionTitle),
      selectedRegionCode: clearRegion
          ? null
          : (selectedRegionCode ?? this.selectedRegionCode),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        general,
        execution,
        areas,
        sectors,
        qcTechnical,
        projectStatusCounts,
        countByType,
        selectedRegionId,
        selectedRegionTitle,
        selectedRegionCode,
        isRefreshing,
      ];
}
