import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/project_stage_assignment.dart';
import '../../domain/repositories/project_stages_repository.dart';

part 'project_stages_state.dart';

class ProjectStagesCubit extends Cubit<ProjectStagesState> {
  ProjectStagesCubit({required this.repository})
      : super(const ProjectStagesInitial());

  final ProjectStagesRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const ProjectStagesLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! ProjectStagesLoaded) {
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
    if (current is ProjectStagesLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const ProjectStagesLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! ProjectStagesLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! ProjectStagesLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<List<ProjectStageOption>> loadProjects() async {
    final result = await repository.getProjects();
    return result.fold((_) => <ProjectStageOption>[], (items) => items);
  }

  Future<List<ProjectStageOption>> loadStepOptions() async {
    final result = await repository.getStepOptions();
    return result.fold((_) => <ProjectStageOption>[], (items) => items);
  }

  Future<bool> createProjectStage(ProjectStageWriteRequest request) async {
    final current = state;
    if (current is! ProjectStagesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createProjectStage(request);

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

  Future<bool> updateProjectStage({
    required String id,
    required ProjectStageWriteRequest request,
  }) async {
    final current = state;
    if (current is! ProjectStagesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateProjectStage(id: id, request: request);

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

  Future<bool> deleteProjectStage(String id) async {
    final current = state;
    if (current is! ProjectStagesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteProjectStage(id);

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
        (state is ProjectStagesLoaded
            ? (state as ProjectStagesLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getProjectStages(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is ProjectStagesLoaded && keepPage) {
          emit(
            (state as ProjectStagesLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(ProjectStagesError(failure.errMessage));
        }
      },
      (response) => emit(
        ProjectStagesLoaded(
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
