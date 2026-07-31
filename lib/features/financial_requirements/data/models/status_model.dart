class StatusModel {
  final String? id;
  final String? title;
  final String? description;

  const StatusModel({this.id, this.title, this.description});

  factory StatusModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const StatusModel();
    return StatusModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
    );
  }
}
