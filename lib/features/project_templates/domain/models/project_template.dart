import 'package:equatable/equatable.dart';

enum TemplateGanttAction {
  /// Save with publish.
  saveWithPublish(0),

  /// Publish only.
  publish(3);

  const TemplateGanttAction(this.apiValue);
  final int apiValue;
}

class ProjectTemplate extends Equatable {
  const ProjectTemplate({
    required this.id,
    required this.name,
    required this.requestType,
    required this.published,
  });

  final String id;
  final String name;
  final int requestType;
  final bool published;

  @override
  List<Object?> get props => [id, name, requestType, published];
}

class ProjectTemplateListResult extends Equatable {
  const ProjectTemplateListResult({
    required this.items,
    required this.totalCount,
  });

  final List<ProjectTemplate> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class TemplateGanttTask extends Equatable {
  const TemplateGanttTask({
    required this.id,
    required this.title,
    required this.sortIndex,
    required this.assignToType,
    required this.isApprovalAction,
    this.isLocal = false,
    this.raw = const {},
  });

  final String id;
  final String title;
  final int sortIndex;
  final int assignToType;
  final bool isApprovalAction;

  /// Task added from the app that is not persisted on the server yet.
  final bool isLocal;

  /// Original API fields kept for round-trip PUT.
  final Map<String, dynamic> raw;

  Map<String, dynamic> toApiJson({required int taskOrder}) {
    return {
      ...raw,
      'id': id,
      'title': title,
      'taskOrder': taskOrder,
      'sortIndex': taskOrder,
      'assignToType': assignToType,
      'isApprovalIdAction': isApprovalAction,
      'isSaved': !isLocal,
      'progress': raw['progress'] ?? 0,
      'isSummary': raw['isSummary'] ?? false,
    };
  }

  TemplateGanttTask copyWith({
    String? id,
    String? title,
    int? sortIndex,
    int? assignToType,
    bool? isApprovalAction,
    bool? isLocal,
    Map<String, dynamic>? raw,
  }) {
    return TemplateGanttTask(
      id: id ?? this.id,
      title: title ?? this.title,
      sortIndex: sortIndex ?? this.sortIndex,
      assignToType: assignToType ?? this.assignToType,
      isApprovalAction: isApprovalAction ?? this.isApprovalAction,
      isLocal: isLocal ?? this.isLocal,
      raw: raw ?? this.raw,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        sortIndex,
        assignToType,
        isApprovalAction,
        isLocal,
        raw,
      ];
}

class TemplateGanttDependency extends Equatable {
  const TemplateGanttDependency({
    required this.predecessorId,
    required this.successorId,
    this.id,
    this.type = 0,
  });

  final String? id;
  final String predecessorId;
  final String successorId;
  final int type;

  Map<String, dynamic> toApiJson() {
    return {
      if (id != null && id!.isNotEmpty) 'id': id,
      'predecessorId': predecessorId,
      'successorId': successorId,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, predecessorId, successorId, type];
}

class TemplateGanttData extends Equatable {
  const TemplateGanttData({
    required this.tasks,
    required this.dependencies,
    this.resources = const [],
    this.resourceAssignments = const [],
  });

  final List<TemplateGanttTask> tasks;
  final List<TemplateGanttDependency> dependencies;
  final List<Map<String, dynamic>> resources;
  final List<Map<String, dynamic>> resourceAssignments;

  Map<String, dynamic> toApiJson() {
    return {
      'tasks': [
        for (var i = 0; i < tasks.length; i++)
          tasks[i].toApiJson(taskOrder: i + 1),
      ],
      'dependancy': dependencies.map((d) => d.toApiJson()).toList(),
      'resources': resources,
      'resourceAssignments': resourceAssignments,
    };
  }

  @override
  List<Object?> get props =>
      [tasks, dependencies, resources, resourceAssignments];
}

class ProjectTemplateWriteRequest extends Equatable {
  const ProjectTemplateWriteRequest({
    required this.name,
    required this.requestType,
  });

  final String name;
  final int requestType;

  Map<String, dynamic> toJson() => {'name': name, 'requestType': requestType};

  @override
  List<Object?> get props => [name, requestType];
}
