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

sealed class ProjectDetailsState extends Equatable {
  const ProjectDetailsState();

  @override
  List<Object?> get props => [];
}

class ProjectDetailsInitial extends ProjectDetailsState {
  const ProjectDetailsInitial();
}

class ProjectDetailsLoading extends ProjectDetailsState {
  const ProjectDetailsLoading();
}

class ProjectDetailsLoaded extends ProjectDetailsState {
  final ProjectDetailsBundle bundle;

  const ProjectDetailsLoaded(this.bundle);

  @override
  List<Object?> get props => [bundle];
}

class ProjectDetailsError extends ProjectDetailsState {
  final String message;

  const ProjectDetailsError(this.message);

  @override
  List<Object?> get props => [message];
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
  final List<RiskMatrixItemDto> risks;

  const ProjectRisksLoaded(this.risks);

  @override
  List<Object?> get props => [risks];
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
