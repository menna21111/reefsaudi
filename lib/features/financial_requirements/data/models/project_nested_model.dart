class ProjectNestedModel {
  final String? id;
  final String? title;
  final String? projectCode;

  const ProjectNestedModel({
    this.id,
    this.title,
    this.projectCode,
  });

  factory ProjectNestedModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProjectNestedModel();
    return ProjectNestedModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      projectCode: json['projectCode'] as String?,
    );
  }
}
