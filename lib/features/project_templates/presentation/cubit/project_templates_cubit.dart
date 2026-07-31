import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/project_template.dart';
import '../../domain/repositories/project_templates_repository.dart';

part 'project_templates_state.dart';

class ProjectTemplatesCubit extends Cubit<ProjectTemplatesState> {
  ProjectTemplatesCubit({required this.repository})
    : super(const ProjectTemplatesInitial());

  final ProjectTemplatesRepository repository;
  static const int defaultPageSize = 20;

  Future<void> load() async {
    emit(const ProjectTemplatesLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! ProjectTemplatesLoaded) {
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
    if (current is ProjectTemplatesLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const ProjectTemplatesLoading());
    }
    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! ProjectTemplatesLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! ProjectTemplatesLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createProjectTemplate(
    ProjectTemplateWriteRequest request,
  ) async {
    final current = state;
    if (current is! ProjectTemplatesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createProjectTemplate(request);
    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _reload(current);
        return true;
      },
    );
  }

  Future<bool> updateProjectTemplate({
    required String id,
    required ProjectTemplateWriteRequest request,
  }) async {
    final current = state;
    if (current is! ProjectTemplatesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateProjectTemplate(
      id: id,
      request: request,
    );
    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _reload(current);
        return true;
      },
    );
  }

  Future<bool> deleteProjectTemplate(String id) async {
    final current = state;
    if (current is! ProjectTemplatesLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteProjectTemplate(id);
    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _reload(current);
        return true;
      },
    );
  }

  Future<void> _reload(ProjectTemplatesLoaded current) => _fetchPage(
    page: current.currentPage,
    searchText: current.searchText,
    keepPage: true,
  );

  Future<void> _fetchPage({
    required int page,
    required String searchText,
    int? pageSize,
    bool keepPage = false,
  }) async {
    final effectivePageSize =
        pageSize ??
        (state is ProjectTemplatesLoaded
            ? (state as ProjectTemplatesLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getProjectTemplates(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is ProjectTemplatesLoaded && keepPage) {
          emit(
            (state as ProjectTemplatesLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
              isSubmitting: false,
            ),
          );
        } else {
          emit(ProjectTemplatesError(failure.errMessage));
        }
      },
      (response) => emit(
        ProjectTemplatesLoaded(
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
