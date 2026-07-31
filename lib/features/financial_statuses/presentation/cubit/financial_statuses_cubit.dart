import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/financial_status.dart';
import '../../domain/repositories/financial_statuses_repository.dart';

part 'financial_statuses_state.dart';

class FinancialStatusesCubit extends Cubit<FinancialStatusesState> {
  FinancialStatusesCubit({required this.repository})
      : super(const FinancialStatusesInitial());

  final FinancialStatusesRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const FinancialStatusesLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! FinancialStatusesLoaded) {
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
    if (current is FinancialStatusesLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const FinancialStatusesLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! FinancialStatusesLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! FinancialStatusesLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createFinancialStatus(FinancialStatusWriteRequest request) async {
    final current = state;
    if (current is! FinancialStatusesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createFinancialStatus(request);

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

  Future<bool> updateFinancialStatus({
    required String id,
    required FinancialStatusWriteRequest request,
  }) async {
    final current = state;
    if (current is! FinancialStatusesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateFinancialStatus(id: id, request: request);

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

  Future<bool> deleteFinancialStatus(String id) async {
    final current = state;
    if (current is! FinancialStatusesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteFinancialStatus(id);

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
        (state is FinancialStatusesLoaded
            ? (state as FinancialStatusesLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getFinancialStatuses(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is FinancialStatusesLoaded && keepPage) {
          emit(
            (state as FinancialStatusesLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(FinancialStatusesError(failure.errMessage));
        }
      },
      (response) => emit(
        FinancialStatusesLoaded(
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
