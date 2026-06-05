import 'project_model.dart';

class ProjectSearchResponseModel {
  final List<ProjectModel> projects;
  final int total;

  const ProjectSearchResponseModel({
    required this.projects,
    required this.total,
  });

  factory ProjectSearchResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return ProjectSearchResponseModel(
      projects: data
          .map((e) => ProjectModel.fromPmoJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? data.length,
    );
  }
}
