import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/sa_region_map_constants.dart';
import '../../data/models/global_statistics_models.dart';
import '../../domain/repositories/statistics_repository.dart';

part 'global_statistics_state.dart';

class GlobalStatisticsCubit extends Cubit<GlobalStatisticsState> {
  GlobalStatisticsCubit({required this.repository})
      : super(const GlobalStatisticsInitial());

  final StatisticsRepository repository;
  int _loadToken = 0;
  List<AreaProjectDto>? _cachedAreas;

  Future<void> load({
    String? regionId,
    String? regionTitle,
    String? regionCode,
    bool reloadAreas = true,
  }) async {
    final token = ++_loadToken;
    final hasRegion = regionId != null && regionId != 'null';
    final previous = state is GlobalStatisticsLoaded
        ? state as GlobalStatisticsLoaded
        : null;

    final keepAreas = !reloadAreas &&
        (_cachedAreas != null || previous?.areas.data != null);
    final cachedAreas = keepAreas
        ? (_cachedAreas ?? previous!.areas.data!)
        : null;

    // First open → full-page loader. Region change / refresh → overlay only.
    if (previous != null) {
      emit(
        previous.copyWith(
          isRefreshing: true,
          selectedRegionId: hasRegion ? regionId : null,
          selectedRegionTitle: hasRegion ? regionTitle : null,
          selectedRegionCode: hasRegion
              ? (regionCode ?? previous.selectedRegionCode)
              : null,
          clearRegion: !hasRegion,
        ),
      );
    } else {
      emit(const GlobalStatisticsLoading());
    }

    final region = hasRegion ? regionId : null;

    final generalFuture = repository.getGeneralStatistics(regionId: region);
    final executionFuture = repository.getExecutionSummary(regionId: region);
    final areasFuture = keepAreas
        ? Future.value(Right<Failure, List<AreaProjectDto>>(cachedAreas!))
        : repository.getAreaProjects();
    final sectorsFuture = repository.getSectorProjects(regionId: region);
    final qcFuture = repository.getQcTechnical(regionId: region);
    final statusFuture = repository.getProjectStatusCounts(regionId: region);
    final typeFuture = repository.getCountByType(regionId: region);

    final results = await Future.wait([
      generalFuture,
      executionFuture,
      areasFuture,
      sectorsFuture,
      qcFuture,
      statusFuture,
      typeFuture,
    ]);

    if (!_canEmit(token)) return;

    final general = results[0] as Either<Failure, GeneralStatisticsDto>;
    final execution = results[1] as Either<Failure, ProjectExecutionSummaryDto>;
    final areas = results[2] as Either<Failure, List<AreaProjectDto>>;
    final sectors = results[3] as Either<Failure, List<SectorProjectDto>>;
    final qc = results[4] as Either<Failure, List<GlobalQcCategoryDto>>;
    final status = results[5] as Either<Failure, List<StatisticsKeyValueDto>>;
    final countByType =
        results[6] as Either<Failure, List<StatisticsKeyValueDto>>;

    areas.fold((_) {}, (data) => _cachedAreas = data);

    emit(
      GlobalStatisticsLoaded(
        general: _section(general),
        execution: _section(execution),
        areas: _section(areas),
        sectors: _section(sectors),
        qcTechnical: _section(qc),
        projectStatusCounts: _section(status),
        countByType: _section(countByType),
        selectedRegionId: hasRegion ? regionId : null,
        selectedRegionTitle: hasRegion ? regionTitle : null,
        selectedRegionCode: hasRegion
            ? (regionCode ?? previous?.selectedRegionCode)
            : null,
        isRefreshing: false,
      ),
    );
  }

  Future<void> selectRegion(AreaProjectDto area) async {
    final code = area.regionCode?.trim().isNotEmpty == true
        ? area.regionCode
        : SaRegionMapConstants.regionCodeAt(
            SaRegionMapConstants.indexForArea(area) ?? -1,
          );

    await load(
      regionId: area.id,
      regionTitle: area.title,
      regionCode: code,
      reloadAreas: false,
    );
  }

  Future<void> clearRegionFilter() async {
    await load(reloadAreas: false);
  }

  Future<void> refresh() async {
    final current = state;
    if (current is GlobalStatisticsLoaded &&
        current.selectedRegionId != null) {
      await load(
        regionId: current.selectedRegionId,
        regionTitle: current.selectedRegionTitle,
        regionCode: current.selectedRegionCode,
        reloadAreas: false,
      );
      return;
    }
    _cachedAreas = null;
    await load();
  }

  StatisticsSection<T> _section<T>(Either<Failure, T> result) {
    return result.fold(
      (failure) => StatisticsSection.failure(failure.errMessage),
      StatisticsSection.success,
    );
  }

  bool _canEmit(int token) => !isClosed && token == _loadToken;
}
