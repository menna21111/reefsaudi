class ProjectNestedModel {
  final String? id;
  final String? title;
  final String? projectCode;
  final String? areaTitle;
  final String? regionId;

  const ProjectNestedModel({
    this.id,
    this.title,
    this.projectCode,
    this.areaTitle,
    this.regionId,
  });

  factory ProjectNestedModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProjectNestedModel();
    return ProjectNestedModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      projectCode: json['projectCode'] as String?,
      areaTitle:
          json['areaTitle']?.toString() ??
          json['area']?.toString() ??
          json['regionTitle']?.toString() ??
          json['region']?.toString(),
      regionId: json['regionId']?.toString() ?? json['areaId']?.toString(),
    );
  }
}
