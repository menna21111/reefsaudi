import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/position.dart';
import '../../domain/repositories/positions_repository.dart';

part 'positions_state.dart';

class PositionsCubit extends Cubit<PositionsState> {
  PositionsCubit({required this.repository}) : super(const PositionsInitial());

  final PositionsRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const PositionsLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! PositionsLoaded) {
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
    if (current is PositionsLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const PositionsLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! PositionsLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! PositionsLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createPosition(PositionWriteRequest request) async {
    final current = state;
    if (current is! PositionsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createPosition(request);

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

  Future<bool> updatePosition({
    required String id,
    required PositionWriteRequest request,
  }) async {
    final current = state;
    if (current is! PositionsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updatePosition(id: id, request: request);

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

  Future<bool> deletePosition(String id) async {
    final current = state;
    if (current is! PositionsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deletePosition(id);

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
        (state is PositionsLoaded
            ? (state as PositionsLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getPositions(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is PositionsLoaded && keepPage) {
          emit(
            (state as PositionsLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(PositionsError(failure.errMessage));
        }
      },
      (response) => emit(
        PositionsLoaded(
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
