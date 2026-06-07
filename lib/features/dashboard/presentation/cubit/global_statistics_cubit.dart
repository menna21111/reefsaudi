import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/global_statistics_models.dart';
import '../../domain/repositories/statistics_repository.dart';

part 'global_statistics_state.dart';

class GlobalStatisticsCubit extends Cubit<GlobalStatisticsState> {
  GlobalStatisticsCubit({required this.repository})
      : super(const GlobalStatisticsInitial());

  final StatisticsRepository repository;
  List<AreaProjectDto>? _cachedAreas;

  Future<void> load({String? regionId, String? regionTitle}) async {
    final previous = state is GlobalStatisticsLoaded
        ? state as GlobalStatisticsLoaded
        : null;

    if (previous != null) {
      emit(previous.copyWith(isRefreshing: true));
    } else {
      emit(const GlobalStatisticsLoading());
    }

    final result = await repository.loadStatistics(
      regionId: regionId,
      regionTitle: regionTitle,
      cachedAreas: _cachedAreas,
    );

    result.fold(
      (failure) => emit(GlobalStatisticsError(failure.errMessage)),
      (bundle) {
        _cachedAreas = bundle.areas;
        emit(GlobalStatisticsLoaded(bundle));
      },
    );
  }

  Future<void> selectRegion(AreaProjectDto area) async {
    await load(regionId: area.id, regionTitle: area.title);
  }

  Future<void> clearRegionFilter() async {
    await load();
  }

  Future<void> refresh() async {
    final current = state;
    if (current is GlobalStatisticsLoaded && current.bundle.selectedRegionId != null) {
      await load(
        regionId: current.bundle.selectedRegionId,
        regionTitle: current.bundle.selectedRegionTitle,
      );
      return;
    }
    _cachedAreas = null;
    await load();
  }
}
