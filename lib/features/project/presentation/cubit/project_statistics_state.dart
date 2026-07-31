part of 'project_statistics_cubit.dart';

sealed class ProjectStatisticsState extends Equatable {
  const ProjectStatisticsState();

  @override
  List<Object?> get props => [];
}

class ProjectStatisticsInitial extends ProjectStatisticsState {
  const ProjectStatisticsInitial();
}

class ProjectStatisticsLoading extends ProjectStatisticsState {
  const ProjectStatisticsLoading();
}

class ProjectStatisticsLoaded extends ProjectStatisticsState {
  final ProjectStatisticsBundle bundle;

  const ProjectStatisticsLoaded(this.bundle);

  @override
  List<Object?> get props => [bundle];
}

class ProjectStatisticsError extends ProjectStatisticsState {
  final String message;

  const ProjectStatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}

enum ProjectDetailsSectionStatus { initial, loading, loaded, error }

class ProjectDetailsSectionState<T> extends Equatable {
  const ProjectDetailsSectionState({
    this.status = ProjectDetailsSectionStatus.initial,
    this.data,
    this.items = const [],
    this.errorMessage,
  });

  final ProjectDetailsSectionStatus status;
  final T? data;
  final List<T> items;
  final String? errorMessage;

  bool get isLoading => status == ProjectDetailsSectionStatus.loading;
  bool get isLoaded => status == ProjectDetailsSectionStatus.loaded;
  bool get hasError => status == ProjectDetailsSectionStatus.error;

  ProjectDetailsSectionState<T> copyWith({
    ProjectDetailsSectionStatus? status,
    T? data,
    List<T>? items,
    String? errorMessage,
    bool clearError = false,
    bool clearData = false,
  }) {
    return ProjectDetailsSectionState<T>(
      status: status ?? this.status,
      data: clearData ? null : (data ?? this.data),
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, data, items, errorMessage];
}

class ProjectDetailsState extends Equatable {
  const ProjectDetailsState({
    required this.projectData,
    required this.editProject,
    required this.executiveSummary,
    required this.achievement,
    required this.risks,
    required this.projectImages,
  });

  final ProjectDetailsSectionState<ProjectDataDto> projectData;
  final ProjectDetailsSectionState<EditProjectFormData> editProject;
  final ProjectDetailsSectionState<ProjectExecutiveSummaryDto> executiveSummary;
  final ProjectDetailsSectionState<ProjectAchievementPointDto> achievement;
  final ProjectDetailsSectionState<RiskMatrixItemDto> risks;
  final ProjectDetailsSectionState<ProjectImageDto> projectImages;

  const ProjectDetailsState.initial()
      : projectData = const ProjectDetailsSectionState(),
        editProject = const ProjectDetailsSectionState(),
        executiveSummary = const ProjectDetailsSectionState(),
        achievement = const ProjectDetailsSectionState(),
        risks = const ProjectDetailsSectionState(),
        projectImages = const ProjectDetailsSectionState();

  ProjectDetailsState copyWith({
    ProjectDetailsSectionState<ProjectDataDto>? projectData,
    ProjectDetailsSectionState<EditProjectFormData>? editProject,
    ProjectDetailsSectionState<ProjectExecutiveSummaryDto>? executiveSummary,
    ProjectDetailsSectionState<ProjectAchievementPointDto>? achievement,
    ProjectDetailsSectionState<RiskMatrixItemDto>? risks,
    ProjectDetailsSectionState<ProjectImageDto>? projectImages,
  }) {
    return ProjectDetailsState(
      projectData: projectData ?? this.projectData,
      editProject: editProject ?? this.editProject,
      executiveSummary: executiveSummary ?? this.executiveSummary,
      achievement: achievement ?? this.achievement,
      risks: risks ?? this.risks,
      projectImages: projectImages ?? this.projectImages,
    );
  }

  @override
  List<Object?> get props => [
        projectData,
        editProject,
        executiveSummary,
        achievement,
        risks,
        projectImages,
      ];
}

sealed class ProjectRisksState extends Equatable {
  const ProjectRisksState();

  @override
  List<Object?> get props => [];
}

class ProjectRisksInitial extends ProjectRisksState {
  const ProjectRisksInitial();
}

class ProjectRisksLoading extends ProjectRisksState {
  const ProjectRisksLoading();
}

class ProjectRisksLoaded extends ProjectRisksState {
  final List<ProjectRiskDto> risks;
  final int totalCount;
  final bool isSubmitting;
  final bool isRefreshing;

  const ProjectRisksLoaded({
    required this.risks,
    required this.totalCount,
    this.isSubmitting = false,
    this.isRefreshing = false,
  });

  ProjectRisksLoaded copyWith({
    List<ProjectRiskDto>? risks,
    int? totalCount,
    bool? isSubmitting,
    bool? isRefreshing,
  }) {
    return ProjectRisksLoaded(
      risks: risks ?? this.risks,
      totalCount: totalCount ?? this.totalCount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [risks, totalCount, isSubmitting, isRefreshing];
}

class ProjectRisksError extends ProjectRisksState {
  final String message;

  const ProjectRisksError(this.message);

  @override
  List<Object?> get props => [message];
}

sealed class ProjectBlueprintState extends Equatable {
  const ProjectBlueprintState();

  @override
  List<Object?> get props => [];
}

class ProjectBlueprintInitial extends ProjectBlueprintState {
  const ProjectBlueprintInitial();
}

class ProjectBlueprintLoading extends ProjectBlueprintState {
  const ProjectBlueprintLoading();
}

class ProjectBlueprintLoaded extends ProjectBlueprintState {
  final List<AchievementManualItemDto> records;
  final int totalCount;
  final int currentPage;
  final int pageSize;

  const ProjectBlueprintLoaded({
    required this.records,
    required this.totalCount,
    required this.currentPage,
    this.pageSize = 10,
  });

  int get totalPages => (totalCount / pageSize).ceil().clamp(1, 999999);

  AchievementManualItemDto? get latestRecord =>
      records.isNotEmpty ? records.first : null;

  @override
  List<Object?> get props => [records, totalCount, currentPage, pageSize];
}

class ProjectBlueprintError extends ProjectBlueprintState {
  final String message;

  const ProjectBlueprintError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectCharterState extends Equatable {
  const ProjectCharterState({
    required this.achievements,
    required this.stages,
    required this.constraints,
    required this.attachments,
  });

  final CharterSectionState<CharterAchievementDto> achievements;
  final CharterSectionState<CharterStageDto> stages;
  final CharterSectionState<CharterConstraintDto> constraints;
  final CharterSectionState<CharterAttachmentDto> attachments;

  const ProjectCharterState.initial()
      : achievements = const CharterSectionState(),
        stages = const CharterSectionState(),
        constraints = const CharterSectionState(),
        attachments = const CharterSectionState();

  ProjectCharterState copyWith({
    CharterSectionState<CharterAchievementDto>? achievements,
    CharterSectionState<CharterStageDto>? stages,
    CharterSectionState<CharterConstraintDto>? constraints,
    CharterSectionState<CharterAttachmentDto>? attachments,
  }) {
    return ProjectCharterState(
      achievements: achievements ?? this.achievements,
      stages: stages ?? this.stages,
      constraints: constraints ?? this.constraints,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  List<Object?> get props => [achievements, stages, constraints, attachments];
}
