import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/project_api_models.dart';
import '../../domain/repositories/project_repository.dart';

part 'project_statistics_state.dart';

class ProjectStatisticsCubit extends Cubit<ProjectStatisticsState> {
  ProjectStatisticsCubit({required this.repository})
      : super(const ProjectStatisticsInitial());

  final ProjectRepository repository;

  Future<void> load(String projectId) async {
    emit(const ProjectStatisticsLoading());
    final result = await repository.getStatisticsBundle(projectId);
    result.fold(
      (failure) => emit(ProjectStatisticsError(failure.errMessage)),
      (bundle) => emit(ProjectStatisticsLoaded(bundle)),
    );
  }
}

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  ProjectDetailsCubit({required this.repository})
      : super(const ProjectDetailsInitial());

  final ProjectRepository repository;

  Future<void> load(String projectId) async {
    emit(const ProjectDetailsLoading());
    final result = await repository.getDetailsBundle(projectId);
    result.fold(
      (failure) => emit(ProjectDetailsError(failure.errMessage)),
      (bundle) => emit(ProjectDetailsLoaded(bundle)),
    );
  }
}

class ProjectRisksCubit extends Cubit<ProjectRisksState> {
  ProjectRisksCubit({required this.repository}) : super(const ProjectRisksInitial());

  final ProjectRepository repository;

  Future<void> load(String projectId) async {
    emit(const ProjectRisksLoading());
    final result = await repository.getRiskMatrix(projectId);
    result.fold(
      (failure) => emit(ProjectRisksError(failure.errMessage)),
      (risks) => emit(ProjectRisksLoaded(risks)),
    );
  }
}

class ProjectBlueprintCubit extends Cubit<ProjectBlueprintState> {
  ProjectBlueprintCubit({required this.repository})
      : super(const ProjectBlueprintInitial());

  static const int pageSize = 10;

  final ProjectRepository repository;
  String? _projectId;

  Future<void> load(String projectId, {int page = 1}) async {
    _projectId = projectId;
    emit(const ProjectBlueprintLoading());

    final skip = (page - 1) * pageSize;
    final result = await repository.getAchievementManual(
      projectId: projectId,
      skip: skip,
      take: pageSize,
    );

    result.fold(
      (failure) => emit(ProjectBlueprintError(failure.errMessage)),
      (response) => emit(
        ProjectBlueprintLoaded(
          records: response.data,
          totalCount: response.totalCount,
          currentPage: page,
          pageSize: pageSize,
        ),
      ),
    );
  }

  Future<void> changePage(int page) async {
    if (_projectId == null) return;
    await load(_projectId!, page: page);
  }
}
