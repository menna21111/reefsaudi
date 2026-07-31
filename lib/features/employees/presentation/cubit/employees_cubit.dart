import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/models/employee.dart';
import '../../domain/repositories/employees_repository.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit({required this.repository}) : super(const EmployeesInitial());

  final EmployeesRepository repository;
  static const int defaultPageSize = 12;

  Future<void> load() async {
    emit(const EmployeesLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! EmployeesLoaded) {
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
    if (current is EmployeesLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const EmployeesLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! EmployeesLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! EmployeesLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<List<EmployeeOption>> loadDesignations() async {
    final result = await repository.getDesignations();
    return result.fold((_) => const [], (items) => items);
  }

  Future<List<EmployeeOption>> loadDepartments() async {
    final result = await repository.getDepartments();
    return result.fold((_) => const [], (items) => items);
  }

  Future<List<EmployeeOption>> loadRoles() async {
    final result = await repository.getRoles();
    return result.fold((_) => const [], (items) => items);
  }

  Future<List<EmployeeOption>> loadSupervisors() async {
    final result = await repository.getSupervisors();
    return result.fold((_) => const [], (items) => items);
  }

  /// Returns `null` on success, or the API error message on failure.
  Future<String?> createEmployee(EmployeeCreateRequest request) async {
    final current = state;
    if (current is! EmployeesLoaded) {
      return 'Unable to create employee right now';
    }

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createEmployee(request);

    return result.fold(
      (failure) {
        emit(current.copyWith(isSubmitting: false));
        return failure.errMessage;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _fetchPage(
          page: current.currentPage,
          searchText: current.searchText,
          keepPage: true,
        );
        return null;
      },
    );
  }

  Future<String?> updateEmployee(EmployeeUpdateRequest request) =>
      _runMutation(() => repository.updateEmployee(request));

  Future<String?> resetPassword({
    required String userId,
    required String newPassword,
  }) => _runMutation(
    () => repository.resetPassword(userId: userId, newPassword: newPassword),
    refreshList: false,
  );

  Future<String?> deleteEmployee(String userId) =>
      _runMutation(() => repository.deleteEmployee(userId));

  Future<String?> _runMutation(
    Future<Either<Failure, void>> Function() action, {
    bool refreshList = true,
  }) async {
    final current = state;
    if (current is! EmployeesLoaded) {
      return 'Unable to update employee right now';
    }

    emit(current.copyWith(isSubmitting: true));
    final result = await action();

    return result.fold(
      (failure) {
        emit(current.copyWith(isSubmitting: false));
        return failure.errMessage;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        if (refreshList) {
          await _fetchPage(
            page: current.currentPage,
            searchText: current.searchText,
            keepPage: true,
          );
        }
        return null;
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
        pageSize ??
        (state is EmployeesLoaded
            ? (state as EmployeesLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getEmployees(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is EmployeesLoaded && keepPage) {
          emit(
            (state as EmployeesLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(EmployeesError(failure.errMessage));
        }
      },
      (response) => emit(
        EmployeesLoaded(
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
