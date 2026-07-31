import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/department.dart';
import '../../domain/repositories/departments_repository.dart';

part 'departments_state.dart';

class DepartmentsCubit extends Cubit<DepartmentsState> {
  DepartmentsCubit({required this.repository})
      : super(const DepartmentsInitial());

  final DepartmentsRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const DepartmentsLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! DepartmentsLoaded) {
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
    if (current is DepartmentsLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const DepartmentsLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! DepartmentsLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! DepartmentsLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createDepartment(DepartmentWriteRequest request) async {
    final current = state;
    if (current is! DepartmentsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createDepartment(request);

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

  Future<bool> updateDepartment({
    required String id,
    required DepartmentWriteRequest request,
  }) async {
    final current = state;
    if (current is! DepartmentsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateDepartment(id: id, request: request);

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

  Future<bool> deleteDepartment(String id) async {
    final current = state;
    if (current is! DepartmentsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteDepartment(id);

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
        (state is DepartmentsLoaded
            ? (state as DepartmentsLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getDepartments(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is DepartmentsLoaded && keepPage) {
          emit(
            (state as DepartmentsLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(DepartmentsError(failure.errMessage));
        }
      },
      (response) => emit(
        DepartmentsLoaded(
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
