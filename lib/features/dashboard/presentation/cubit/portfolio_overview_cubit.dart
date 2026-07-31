import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/portfolio_overview_models.dart';
import '../../domain/repositories/statistics_repository.dart';

part 'portfolio_overview_state.dart';

class PortfolioOverviewCubit extends Cubit<PortfolioOverviewState> {
  PortfolioOverviewCubit({required this.repository})
      : super(const PortfolioOverviewInitial());

  final StatisticsRepository repository;
  List<BrandDto>? _cachedBrands;

  Future<void> load({String? brandId, String? brandTitle}) async {
    final previous = state is PortfolioOverviewLoaded
        ? state as PortfolioOverviewLoaded
        : null;

    if (previous != null) {
      emit(previous.copyWith(isRefreshing: true));
    } else {
      emit(const PortfolioOverviewLoading());
    }

    final result = await repository.loadPortfolioOverview(
      brandId: brandId,
      brandTitle: brandTitle,
      cachedBrands: _cachedBrands,
    );

    result.fold(
      (failure) => emit(PortfolioOverviewError(failure.errMessage)),
      (bundle) {
        _cachedBrands = bundle.brands;
        emit(PortfolioOverviewLoaded(bundle: bundle));
      },
    );
  }

  Future<void> selectBrand(BrandDto brand) async {
    await load(brandId: brand.id, brandTitle: brand.title);
  }

  Future<void> clearBrandFilter() async {
    await load();
  }

  Future<void> refresh() async {
    final current = state;
    if (current is PortfolioOverviewLoaded &&
        current.bundle.selectedBrandId != null) {
      await load(
        brandId: current.bundle.selectedBrandId,
        brandTitle: current.bundle.selectedBrandTitle,
      );
      return;
    }
    await load();
  }
}
