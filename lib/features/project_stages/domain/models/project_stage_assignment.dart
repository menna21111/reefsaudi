import 'package:equatable/equatable.dart';

class ProjectStageAssignment extends Equatable {
  const ProjectStageAssignment({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.pStepId,
    required this.pStepTitle,
    required this.assignedDate,
    this.isCompleted = false,
  });

  final String id;
  final String projectId;
  final String projectTitle;
  final String pStepId;
  final String pStepTitle;
  final String assignedDate;
  final bool isCompleted;

  @override
  List<Object?> get props => [
        id,
        projectId,
        projectTitle,
        pStepId,
        pStepTitle,
        assignedDate,
        isCompleted,
      ];
}

class ProjectStageListResult extends Equatable {
  const ProjectStageListResult({
    required this.items,
    required this.totalCount,
  });

  final List<ProjectStageAssignment> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class ProjectStageWriteRequest extends Equatable {
  const ProjectStageWriteRequest({
    required this.projectId,
    required this.pStepId,
    required this.assignedDate,
  });

  final String projectId;
  final String pStepId;
  final String assignedDate;

  @override
  List<Object?> get props => [projectId, pStepId, assignedDate];
}

class ProjectStageOption extends Equatable {
  const ProjectStageOption({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
