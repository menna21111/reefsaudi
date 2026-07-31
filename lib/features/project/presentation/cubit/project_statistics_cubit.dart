import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/project_api_models.dart';
import '../../data/models/project_charter_models.dart';
import '../../data/models/achievement_manual_request.dart';
import '../../data/datasources/edit_project_remote_data_source.dart';
import '../../domain/repositories/project_repository.dart';
import 'edit_project_state.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import '../../../risk_management/domain/repositories/risk_repository.dart';

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
  ProjectDetailsCubit({
    required this.repository,
    required this.editDataSource,
  }) : super(const ProjectDetailsState.initial());

  final ProjectRepository repository;
  final EditProjectRemoteDataSource editDataSource;
  String? _projectId;

  Future<void> load(String projectId) async {
    _projectId = projectId;
    await Future.wait([
      loadProjectData(),
      loadEditProject(),
      loadExecutiveSummary(),
      loadAchievement(),
      loadRisks(),
      loadProjectImages(),
    ]);
  }

  Future<void> refresh() async {
    final projectId = _projectId;
    if (projectId == null) return;
    await load(projectId);
  }

  Future<void> refreshSilently() async {
    final projectId = _projectId;
    if (projectId == null) return;

    await Future.wait([
      _reloadProjectDataSilently(),
      _reloadEditProjectSilently(),
      _reloadExecutiveSummarySilently(),
      _reloadAchievementSilently(),
      _reloadProjectImagesSilently(),
    ]);
  }

  Future<void> _reloadProjectDataSilently() async {
    final projectId = _projectId;
    if (projectId == null || isClosed) return;

    final result = await repository.getProjectData(projectId);
    if (isClosed) return;

    result.fold((_) {}, (data) {
      emit(
        state.copyWith(
          projectData: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            data: data,
          ),
        ),
      );
    });
  }

  Future<void> _reloadEditProjectSilently() async {
    final projectId = _projectId;
    if (projectId == null || isClosed) return;

    try {
      final dto = await editDataSource.getProjectForEdit(projectId);
      if (isClosed) return;
      final form = EditProjectFormData.fromDto(dto);
      emit(
        state.copyWith(
          editProject: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            data: form,
          ),
        ),
      );
    } catch (_) {}
  }

  Future<void> _reloadExecutiveSummarySilently() async {
    final projectId = _projectId;
    if (projectId == null || isClosed) return;

    final result = await repository.getExecutiveSummary(projectId);
    if (isClosed) return;

    result.fold((_) {}, (summary) {
      final projectData = state.projectData.data;
      final resolved = summary ??
          (projectData != null
              ? ProjectExecutiveSummaryDto.fromProjectData(projectData)
              : null);
      if (resolved == null) return;

      emit(
        state.copyWith(
          executiveSummary: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            data: resolved,
          ),
        ),
      );
    });
  }

  Future<void> _reloadAchievementSilently() async {
    final projectId = _projectId;
    if (projectId == null || isClosed) return;

    final result = await repository.getProjectAchievement(projectId);
    if (isClosed) return;

    result.fold((_) {}, (items) {
      emit(
        state.copyWith(
          achievement: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            items: items,
          ),
        ),
      );
    });
  }

  Future<void> loadProjectData() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        projectData: state.projectData.copyWith(
          status: ProjectDetailsSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final result = await repository.getProjectData(projectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          projectData: state.projectData.copyWith(
            status: ProjectDetailsSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (data) => emit(
        state.copyWith(
          projectData: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            data: data,
          ),
        ),
      ),
    );
  }

  Future<void> loadEditProject() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        editProject: state.editProject.copyWith(
          status: ProjectDetailsSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    try {
      final dto = await editDataSource.getProjectForEdit(projectId);
      final form = EditProjectFormData.fromDto(dto);
      emit(
        state.copyWith(
          editProject: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            data: form,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          editProject: state.editProject.copyWith(
            status: ProjectDetailsSectionStatus.error,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> loadExecutiveSummary() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        executiveSummary: state.executiveSummary.copyWith(
          status: ProjectDetailsSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final result = await repository.getExecutiveSummary(projectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          executiveSummary: state.executiveSummary.copyWith(
            status: ProjectDetailsSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (summary) {
        final projectData = state.projectData.data;
        final resolved = summary ??
            (projectData != null
                ? ProjectExecutiveSummaryDto.fromProjectData(projectData)
                : ProjectExecutiveSummaryDto(
                    actual: 0,
                    planned: 0,
                    diffraction: 0,
                    achievementTitle: '',
                    projectId: projectId,
                    stepTitle: '',
                    isFinal: false,
                    assignedDate: '',
                    completionPercent: 0,
                    statusCode: 0,
                    stepStatus: '',
                    statusColor: '',
                  ));

        emit(
          state.copyWith(
            executiveSummary: ProjectDetailsSectionState(
              status: ProjectDetailsSectionStatus.loaded,
              data: resolved,
            ),
          ),
        );
      },
    );
  }

  Future<void> loadAchievement() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        achievement: state.achievement.copyWith(
          status: ProjectDetailsSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final result = await repository.getProjectAchievement(projectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          achievement: state.achievement.copyWith(
            status: ProjectDetailsSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (items) => emit(
        state.copyWith(
          achievement: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            items: items,
          ),
        ),
      ),
    );
  }

  Future<void> _reloadProjectImagesSilently() async {
    final projectId = _projectId?.trim();
    if (projectId == null || projectId.isEmpty || isClosed) return;

    final result = await repository.getProjectImages(projectId);
    if (isClosed) return;

    result.fold((_) {}, (items) {
      emit(
        state.copyWith(
          projectImages: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            items: items,
          ),
        ),
      );
    });
  }

  Future<void> loadProjectImages() async {
    final projectId = _projectId?.trim();
    if (projectId == null || projectId.isEmpty) return;

    emit(
      state.copyWith(
        projectImages: state.projectImages.copyWith(
          status: ProjectDetailsSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final result = await repository.getProjectImages(projectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          projectImages: state.projectImages.copyWith(
            status: ProjectDetailsSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (items) => emit(
        state.copyWith(
          projectImages: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            items: items,
          ),
        ),
      ),
    );
  }

  Future<void> loadRisks() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        risks: state.risks.copyWith(
          status: ProjectDetailsSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final result = await repository.getRiskMatrix(projectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          risks: state.risks.copyWith(
            status: ProjectDetailsSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (items) => emit(
        state.copyWith(
          risks: ProjectDetailsSectionState(
            status: ProjectDetailsSectionStatus.loaded,
            items: items,
          ),
        ),
      ),
    );
  }
}

class ProjectRisksCubit extends Cubit<ProjectRisksState> {
  ProjectRisksCubit({required this.repository})
      : super(const ProjectRisksInitial());

  final RiskRepository repository;
  String? _projectId;
  static const int pageSize = 10;

  Future<void> load(String projectId, {bool silent = false}) async {
    _projectId = projectId;
    final current = state;
    if (!silent) {
      emit(const ProjectRisksLoading());
    } else if (current is ProjectRisksLoaded) {
      emit(current.copyWith(isRefreshing: true));
    }

    final result = await repository.getProjectRisksByProjectId(
      projectId,
      skip: 0,
      take: pageSize,
    );

    result.fold(
      (failure) {
        if (silent && current is ProjectRisksLoaded) {
          emit(current.copyWith(isRefreshing: false));
        } else {
          emit(ProjectRisksError(failure.errMessage));
        }
      },
      (response) => emit(
        ProjectRisksLoaded(
          risks: response.data,
          totalCount: response.totalCount,
        ),
      ),
    );
  }

  Future<List<AccountDxItemDto>> fetchAccounts() async {
    final result = await repository.getAccounts();
    return result.fold((_) => <AccountDxItemDto>[], (items) => items);
  }

  Future<bool> createRisk(ProjectRiskWriteRequest request) async {
    final projectId = _projectId;
    if (projectId == null) return false;

    final current = state;
    if (current is ProjectRisksLoaded) {
      emit(current.copyWith(isSubmitting: true));
    }

    final result = await repository.createProjectRiskForProject(
      projectId: projectId,
      request: request,
    );

    return result.fold(
      (_) {
        if (current is ProjectRisksLoaded) {
          emit(current.copyWith(isSubmitting: false));
        }
        return false;
      },
      (_) async {
        await load(projectId, silent: true);
        return true;
      },
    );
  }

  Future<bool> updateRisk(ProjectRiskWriteRequest request) async {
    final projectId = _projectId;
    if (projectId == null) return false;

    final current = state;
    if (current is ProjectRisksLoaded) {
      emit(current.copyWith(isSubmitting: true));
    }

    final result = await repository.updateProjectRisk(request);

    return result.fold(
      (_) {
        if (current is ProjectRisksLoaded) {
          emit(current.copyWith(isSubmitting: false));
        }
        return false;
      },
      (_) async {
        await load(projectId, silent: true);
        return true;
      },
    );
  }

  Future<bool> deleteRisk(String riskId) async {
    final projectId = _projectId;
    if (projectId == null) return false;

    final current = state;
    if (current is ProjectRisksLoaded) {
      emit(current.copyWith(isSubmitting: true));
    }

    final result = await repository.deleteProjectRisk(riskId);

    return result.fold(
      (_) {
        if (current is ProjectRisksLoaded) {
          emit(current.copyWith(isSubmitting: false));
        }
        return false;
      },
      (_) async {
        await load(projectId, silent: true);
        return true;
      },
    );
  }
}

class ProjectBlueprintCubit extends Cubit<ProjectBlueprintState> {
  ProjectBlueprintCubit({required this.repository})
      : super(const ProjectBlueprintInitial());

  static const int pageSize = 10;

  final ProjectRepository repository;
  String? _projectId;

  Future<void> load(String projectId, {int page = 1, bool silent = false}) async {
    _projectId = projectId;
    final current = state;
    if (!silent) {
      emit(const ProjectBlueprintLoading());
    }

    final skip = (page - 1) * pageSize;
    final result = await repository.getAchievementManual(
      projectId: projectId,
      skip: skip,
      take: pageSize,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (silent && current is ProjectBlueprintLoaded) {
          return;
        }
        emit(ProjectBlueprintError(failure.errMessage));
      },
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

  Future<void> _reloadCurrentPageSilently() async {
    final projectId = _projectId;
    if (projectId == null) return;
    final page = state is ProjectBlueprintLoaded
        ? (state as ProjectBlueprintLoaded).currentPage
        : 1;
    await load(projectId, page: page, silent: true);
  }

  Future<String?> createAchievement({
    required DateTime monthYear,
    required double planned,
    required double actual,
  }) async {
    final projectId = _projectId;
    if (projectId == null) return 'Unexpected Error, Please try again!';

    final result = await repository.createAchievementManual(
      CreateAchievementManualRequest(
        projectId: projectId,
        monthYear: formatAchievementMonthYear(monthYear),
        planned: planned,
        actual: actual,
      ),
    );

    return await result.fold(
      (failure) async => failure.errMessage,
      (_) async {
        await _reloadCurrentPageSilently();
        return null;
      },
    );
  }

  Future<String?> updateAchievement({
    required AchievementManualItemDto record,
    required DateTime monthYear,
    required double planned,
    required double actual,
  }) async {
    final result = await repository.updateAchievementManual(
      UpdateAchievementManualRequest(
        key: record.id,
        projectId: record.projectId,
        monthYear: formatAchievementMonthYear(monthYear),
        planned: planned,
        actual: actual,
      ),
    );

    return await result.fold(
      (failure) async => failure.errMessage,
      (_) async {
        await _reloadCurrentPageSilently();
        return null;
      },
    );
  }

  Future<String?> deleteAchievement(String key) async {
    final result = await repository.deleteAchievementManual(key);

    return await result.fold(
      (failure) async => failure.errMessage,
      (_) async {
        await _reloadCurrentPageSilently();
        return null;
      },
    );
  }

  Future<void> changePage(int page) async {
    if (_projectId == null) return;
    await load(_projectId!, page: page);
  }
}

class ProjectCharterCubit extends Cubit<ProjectCharterState> {
  ProjectCharterCubit({required this.repository})
      : super(const ProjectCharterState.initial());

  final ProjectRepository repository;
  String? _projectId;
  String _achievementsSearch = '';
  String _stagesSearch = '';
  String _constraintsSearch = '';
  String _attachmentsSearch = '';

  Future<void> load(String projectId) async {
    _projectId = projectId;
    _achievementsSearch = '';
    _stagesSearch = '';
    _constraintsSearch = '';
    _attachmentsSearch = '';
    emit(
      const ProjectCharterState(
        achievements: CharterSectionState(status: CharterSectionStatus.loading),
        stages: CharterSectionState(status: CharterSectionStatus.loading),
        constraints: CharterSectionState(status: CharterSectionStatus.loading),
        attachments: CharterSectionState(status: CharterSectionStatus.loading),
      ),
    );

    final charterResult = await repository.getProjectCharter(projectId);
    if (isClosed || _projectId != projectId) return;

    final hasCharter = charterResult.fold(
      (failure) {
        emit(_charterErrorState(failure.errMessage));
        return false;
      },
      (charter) {
        if (charter.id.trim().isEmpty) {
          emit(_emptyCharterState());
          return false;
        }
        return true;
      },
    );

    if (!hasCharter) return;

    final results = await Future.wait([
      repository.getCharterAchievements(projectId, search: _achievementsSearch),
      repository.getCharterStages(projectId, search: _stagesSearch),
      repository.getCharterConstraints(projectId, search: _constraintsSearch),
      repository.getCharterAttachments(projectId, search: _attachmentsSearch),
    ]);

    if (isClosed || _projectId != projectId) return;

    final achievementsResult =
        results[0] as Either<Failure, CharterPagedResponse<CharterAchievementDto>>;
    final stagesResult =
        results[1] as Either<Failure, CharterPagedResponse<CharterStageDto>>;
    final constraintsResult =
        results[2] as Either<Failure, CharterPagedResponse<CharterConstraintDto>>;
    final attachmentsResult =
        results[3] as Either<Failure, List<CharterAttachmentDto>>;

    emit(
      ProjectCharterState(
        achievements: _charterPagedSection<CharterAchievementDto>(
          achievementsResult,
        ),
        stages: _charterPagedSection<CharterStageDto>(stagesResult),
        constraints: _charterPagedSection<CharterConstraintDto>(
          constraintsResult,
        ),
        attachments: attachmentsResult.fold(
          (failure) => CharterSectionState(
            status: CharterSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
          (items) => CharterSectionState(
            status: CharterSectionStatus.loaded,
            items: items,
            totalCount: items.length,
          ),
        ),
      ),
    );
  }

  ProjectCharterState _charterErrorState(String message) {
    CharterSectionState<T> section<T>() => CharterSectionState<T>(
          status: CharterSectionStatus.error,
          errorMessage: message,
        );

    return ProjectCharterState(
      achievements: section<CharterAchievementDto>(),
      stages: section<CharterStageDto>(),
      constraints: section<CharterConstraintDto>(),
      attachments: section<CharterAttachmentDto>(),
    );
  }

  ProjectCharterState _emptyCharterState() {
    return const ProjectCharterState(
      achievements: CharterSectionState(status: CharterSectionStatus.loaded),
      stages: CharterSectionState(status: CharterSectionStatus.loaded),
      constraints: CharterSectionState(status: CharterSectionStatus.loaded),
      attachments: CharterSectionState(status: CharterSectionStatus.loaded),
    );
  }

  CharterSectionState<T> _charterPagedSection<T>(
    Either<Failure, CharterPagedResponse<T>> result,
  ) {
    return result.fold(
      (failure) => CharterSectionState<T>(
        status: CharterSectionStatus.error,
        errorMessage: failure.errMessage,
      ),
      (response) => CharterSectionState<T>(
        status: CharterSectionStatus.loaded,
        items: response.data,
        totalCount: response.totalCount,
      ),
    );
  }

  Future<void> refresh() async {
    final projectId = _projectId;
    if (projectId == null) return;
    await load(projectId);
  }

  Future<bool> _hasCharter(String projectId) async {
    final charterResult = await repository.getProjectCharter(projectId);
    if (isClosed || _projectId != projectId) return false;
    return charterResult.fold(
      (_) => false,
      (charter) => charter.id.trim().isNotEmpty,
    );
  }

  Future<void> searchAchievements(String query) async {
    _achievementsSearch = query.trim();
    await loadAchievements();
  }

  Future<void> searchStages(String query) async {
    _stagesSearch = query.trim();
    await loadStages();
  }

  Future<void> searchConstraints(String query) async {
    _constraintsSearch = query.trim();
    await loadConstraints();
  }

  Future<void> searchAttachments(String query) async {
    _attachmentsSearch = query.trim();
    await loadAttachments();
  }

  Future<void> loadAchievements() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        achievements: state.achievements.copyWith(
          status: CharterSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final hasCharter = await _hasCharter(projectId);
    if (!hasCharter) {
      if (!isClosed && _projectId == projectId) {
        emit(
          state.copyWith(
            achievements: state.achievements.copyWith(
              status: CharterSectionStatus.loaded,
            ),
          ),
        );
      }
      return;
    }

    final result = await repository.getCharterAchievements(
      projectId,
      search: _achievementsSearch,
    );
    if (isClosed || _projectId != projectId) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          achievements: state.achievements.copyWith(
            status: CharterSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (response) => emit(
        state.copyWith(
          achievements: CharterSectionState(
            status: CharterSectionStatus.loaded,
            items: response.data,
            totalCount: response.totalCount,
          ),
        ),
      ),
    );
  }

  Future<void> loadStages() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        stages: state.stages.copyWith(
          status: CharterSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final hasCharter = await _hasCharter(projectId);
    if (!hasCharter) {
      if (!isClosed && _projectId == projectId) {
        emit(
          state.copyWith(
            stages: state.stages.copyWith(
              status: CharterSectionStatus.loaded,
            ),
          ),
        );
      }
      return;
    }

    final result = await repository.getCharterStages(
      projectId,
      search: _stagesSearch,
    );
    if (isClosed || _projectId != projectId) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          stages: state.stages.copyWith(
            status: CharterSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (response) => emit(
        state.copyWith(
          stages: CharterSectionState(
            status: CharterSectionStatus.loaded,
            items: response.data,
            totalCount: response.totalCount,
          ),
        ),
      ),
    );
  }

  Future<void> loadConstraints() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        constraints: state.constraints.copyWith(
          status: CharterSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final hasCharter = await _hasCharter(projectId);
    if (!hasCharter) {
      if (!isClosed && _projectId == projectId) {
        emit(
          state.copyWith(
            constraints: state.constraints.copyWith(
              status: CharterSectionStatus.loaded,
            ),
          ),
        );
      }
      return;
    }

    final result = await repository.getCharterConstraints(
      projectId,
      search: _constraintsSearch,
    );
    if (isClosed || _projectId != projectId) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          constraints: state.constraints.copyWith(
            status: CharterSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (response) => emit(
        state.copyWith(
          constraints: CharterSectionState(
            status: CharterSectionStatus.loaded,
            items: response.data,
            totalCount: response.totalCount,
          ),
        ),
      ),
    );
  }

  Future<void> loadAttachments() async {
    final projectId = _projectId;
    if (projectId == null) return;

    emit(
      state.copyWith(
        attachments: state.attachments.copyWith(
          status: CharterSectionStatus.loading,
          clearError: true,
        ),
      ),
    );

    final hasCharter = await _hasCharter(projectId);
    if (!hasCharter) {
      if (!isClosed && _projectId == projectId) {
        emit(
          state.copyWith(
            attachments: state.attachments.copyWith(
              status: CharterSectionStatus.loaded,
            ),
          ),
        );
      }
      return;
    }

    final result = await repository.getCharterAttachments(
      projectId,
      search: _attachmentsSearch,
    );
    if (isClosed || _projectId != projectId) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          attachments: state.attachments.copyWith(
            status: CharterSectionStatus.error,
            errorMessage: failure.errMessage,
          ),
        ),
      ),
      (items) => emit(
        state.copyWith(
          attachments: CharterSectionState(
            status: CharterSectionStatus.loaded,
            items: items,
            totalCount: items.length,
          ),
        ),
      ),
    );
  }

  Future<Either<Failure, void>> createAchievement(CharterTextWriteRequest request) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.createCharterAchievement(projectId, request);
    if (result.isRight()) {
      await loadAchievements();
    }
    return result;
  }

  Future<Either<Failure, void>> updateAchievement(CharterTextWriteRequest request) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.updateCharterAchievement(projectId, request);
    if (result.isRight()) {
      await loadAchievements();
    }
    return result;
  }

  Future<Either<Failure, void>> deleteAchievement(String key) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.deleteCharterAchievement(projectId, key);
    if (result.isRight()) {
      await loadAchievements();
    }
    return result;
  }

  Future<Either<Failure, void>> createStage(CharterStageWriteRequest request) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.createCharterStage(projectId, request);
    if (result.isRight()) {
      await loadStages();
    }
    return result;
  }

  Future<Either<Failure, void>> updateStage(CharterStageWriteRequest request) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.updateCharterStage(projectId, request);
    if (result.isRight()) {
      await loadStages();
    }
    return result;
  }

  Future<Either<Failure, void>> deleteStage(String key) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.deleteCharterStage(projectId, key);
    if (result.isRight()) {
      await loadStages();
    }
    return result;
  }

  Future<Either<Failure, void>> createConstraint(
    CharterConstraintWriteRequest request,
  ) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.createCharterConstraint(projectId, request);
    if (result.isRight()) {
      await loadConstraints();
    }
    return result;
  }

  Future<Either<Failure, void>> updateConstraint(
    CharterConstraintWriteRequest request,
  ) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.updateCharterConstraint(projectId, request);
    if (result.isRight()) {
      await loadConstraints();
    }
    return result;
  }

  Future<Either<Failure, void>> deleteConstraint(String key) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.deleteCharterConstraint(projectId, key);
    if (result.isRight()) {
      await loadConstraints();
    }
    return result;
  }

  Future<Either<Failure, void>> uploadAttachment(String filePath) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.uploadCharterAttachment(projectId, filePath);
    if (result.isRight()) {
      await loadAttachments();
    }
    return result;
  }

  Future<Either<Failure, void>> deleteAttachment(String key) async {
    final projectId = _projectId;
    if (projectId == null) return Left(ServerFailure('Missing project id'));
    final result = await repository.deleteCharterAttachment(projectId, key);
    if (result.isRight()) {
      await loadAttachments();
    }
    return result;
  }
}
