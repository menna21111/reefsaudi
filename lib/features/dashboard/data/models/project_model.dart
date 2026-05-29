import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.budget,
    required super.status,
    required super.progress,
    required super.entityName,
    super.daysLeft,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      budget: (json['budget'] as num).toDouble(),
      status: json['status'] as String,
      progress: (json['progress'] as num).toDouble(),
      entityName: json['entityName'] as String,
      daysLeft: json['daysLeft'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'budget': budget,
      'status': status,
      'progress': progress,
      'entityName': entityName,
      'daysLeft': daysLeft,
    };
  }
}
