import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/pm_status.dart';
import '../../domain/repositories/pm_statuses_repository.dart';

part 'pm_statuses_state.dart';

class PmStatusesCubit extends Cubit<PmStatusesState> {
  PmStatusesCubit({required this.repository}) : super(const PmStatusesInitial());

  final PmStatusesRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const PmStatusesLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! PmStatusesLoaded) {
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
    if (current is PmStatusesLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const PmStatusesLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! PmStatusesLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! PmStatusesLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createPmStatus(PmStatusWriteRequest request) async {
    final current = state;
    if (current is! PmStatusesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createPmStatus(request);

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

  Future<bool> updatePmStatus({
    required String id,
    required PmStatusWriteRequest request,
  }) async {
    final current = state;
    if (current is! PmStatusesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updatePmStatus(id: id, request: request);

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

  Future<bool> deletePmStatus(String id) async {
    final current = state;
    if (current is! PmStatusesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deletePmStatus(id);

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
        (state is PmStatusesLoaded
            ? (state as PmStatusesLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getPmStatuses(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is PmStatusesLoaded && keepPage) {
          emit(
            (state as PmStatusesLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(PmStatusesError(failure.errMessage));
        }
      },
      (response) => emit(
        PmStatusesLoaded(
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
