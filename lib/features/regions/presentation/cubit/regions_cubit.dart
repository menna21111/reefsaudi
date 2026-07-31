import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/region.dart';
import '../../domain/repositories/regions_repository.dart';

part 'regions_state.dart';

class RegionsCubit extends Cubit<RegionsState> {
  RegionsCubit({required this.repository}) : super(const RegionsInitial());

  final RegionsRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const RegionsLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! RegionsLoaded) {
      await load();
      return;
    }

    emit(current.copyWith(isRefreshing: true));
    await _fetchPage(
      page: current.currentPage,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> search(String query) async {
    final current = state;
    if (current is RegionsLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const RegionsLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! RegionsLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! RegionsLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createRegion(RegionWriteRequest request) async {
    final current = state;
    if (current is! RegionsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createRegion(request);

    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _fetchPage(
          page: current.currentPage,
          searchText: current.searchText,
          keepPage: true,
        );
        return true;
      },
    );
  }

  Future<bool> updateRegion({
    required String id,
    required RegionWriteRequest request,
  }) async {
    final current = state;
    if (current is! RegionsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateRegion(id: id, request: request);

    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _fetchPage(
          page: current.currentPage,
          searchText: current.searchText,
          keepPage: true,
        );
        return true;
      },
    );
  }

  Future<bool> deleteRegion(String id) async {
    final current = state;
    if (current is! RegionsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteRegion(id);

    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _fetchPage(
          page: current.currentPage,
          searchText: current.searchText,
          keepPage: true,
        );
        return true;
      },
    );
  }

  Future<void> _fetchPage({
    required int page,
    required String searchText,
    int? pageSize,
    bool keepPage = false,
  }) async {
    final effectivePageSize = pageSize ??
        (state is RegionsLoaded
            ? (state as RegionsLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getRegions(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is RegionsLoaded && keepPage) {
          emit(
            (state as RegionsLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(RegionsError(failure.errMessage));
        }
      },
      (response) => emit(
        RegionsLoaded(
          items: response.items,
          totalCount: response.totalCount,
          currentPage: page,
          pageSize: effectivePageSize,
          searchText: searchText,
        ),
      ),
    );
  }
}
