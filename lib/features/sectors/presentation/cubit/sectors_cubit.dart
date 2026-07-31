import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/sector.dart';
import '../../domain/repositories/sectors_repository.dart';

part 'sectors_state.dart';

class SectorsCubit extends Cubit<SectorsState> {
  SectorsCubit({required this.repository}) : super(const SectorsInitial());

  final SectorsRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const SectorsLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! SectorsLoaded) {
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
    if (current is SectorsLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const SectorsLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! SectorsLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! SectorsLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createSector(SectorWriteRequest request) async {
    final current = state;
    if (current is! SectorsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createSector(request);

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

  Future<bool> updateSector({
    required String id,
    required SectorWriteRequest request,
  }) async {
    final current = state;
    if (current is! SectorsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateSector(id: id, request: request);

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

  Future<bool> deleteSector(String id) async {
    final current = state;
    if (current is! SectorsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteSector(id);

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
    final effectivePageSize =
        pageSize ?? (state is SectorsLoaded ? (state as SectorsLoaded).pageSize : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getSectors(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is SectorsLoaded && keepPage) {
          emit((state as SectorsLoaded).copyWith(isRefreshing: false, isPageLoading: false));
        } else {
          emit(SectorsError(failure.errMessage));
        }
      },
      (response) => emit(
        SectorsLoaded(
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
