/// Published project template from `Project/Template/published`.
class ProjectTemplateDto {
  final String id;
  final String name;
  final int? requestType;
  final bool published;

  const ProjectTemplateDto({
    required this.id,
    required this.name,
    this.requestType,
    this.published = true,
  });

  factory ProjectTemplateDto.fromJson(Map<String, dynamic> json) {
    return ProjectTemplateDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      requestType: _toNullableInt(json['requestType']),
      published: json['published'] == true,
    );
  }
}

List<ProjectTemplateDto> parseProjectTemplates(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(ProjectTemplateDto.fromJson)
      .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
      .toList();
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

/// Maps each forms-management field to API `requestType`.
abstract class ProjectTemplateRequestType {
  static const int receiveBusiness = 0;
  static const int subcontractorAdoption = 1;
  static const int documentsAdoption = 2;
  static const int executiveBoardsAdoption = 3;
  static const int materialsAdoption = 4;
  static const int materialsReceiveAndInspect = 5;
  static const int informationRequest = 6;
  static const int siteWorkInstructions = 7;
  static const int paymentCertificateAdoption = 8;
  static const int siteObservationReport = 9;
  static const int nonConformanceReport = 10;
}
