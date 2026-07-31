import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/project_type.dart';
import '../../domain/repositories/project_types_repository.dart';

part 'project_types_state.dart';

class ProjectTypesCubit extends Cubit<ProjectTypesState> {
  ProjectTypesCubit({required this.repository}) : super(const ProjectTypesInitial());

  final ProjectTypesRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const ProjectTypesLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! ProjectTypesLoaded) {
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
    if (current is ProjectTypesLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const ProjectTypesLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! ProjectTypesLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! ProjectTypesLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createProjectType(ProjectTypeWriteRequest request) async {
    final current = state;
    if (current is! ProjectTypesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createProjectType(request);

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

  Future<bool> updateProjectType({
    required String id,
    required ProjectTypeWriteRequest request,
  }) async {
    final current = state;
    if (current is! ProjectTypesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateProjectType(id: id, request: request);

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

  Future<bool> deleteProjectType(String id) async {
    final current = state;
    if (current is! ProjectTypesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteProjectType(id);

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
        (state is ProjectTypesLoaded
            ? (state as ProjectTypesLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getProjectTypes(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is ProjectTypesLoaded && keepPage) {
          emit(
            (state as ProjectTypesLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(ProjectTypesError(failure.errMessage));
        }
      },
      (response) => emit(
        ProjectTypesLoaded(
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
