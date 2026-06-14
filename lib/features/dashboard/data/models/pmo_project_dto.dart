int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

num _toNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value;
  return num.tryParse(value.toString()) ?? 0;
}

String _toString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

List<String> _toStringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((e) => e?.toString() ?? '').toList();
}

List<dynamic> _toDynamicList(dynamic value) {
  if (value is! List) return const [];
  return value;
}

Map<String, dynamic>? _toMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return null;
}

class PmoStepStatusDto {
  final String title;
  final String titleAr;
  final String color;

  const PmoStepStatusDto({
    required this.title,
    required this.titleAr,
    required this.color,
  });

  factory PmoStepStatusDto.fromJson(Map<String, dynamic> json) {
    return PmoStepStatusDto(
      title: _toString(json['title']),
      titleAr: _toString(json['titleAr']),
      color: _toString(json['color']),
    );
  }
}

class PmoCurrentStepDto {
  final int type;
  final String startedAt;
  final int durationInDays;
  final num? progressRatio;
  final PmoStepStatusDto status;

  const PmoCurrentStepDto({
    required this.type,
    required this.startedAt,
    required this.durationInDays,
    this.progressRatio,
    required this.status,
  });

  factory PmoCurrentStepDto.fromJson(Map<String, dynamic> json) {
    final statusJson = _toMap(json['status']);
    return PmoCurrentStepDto(
      type: _toInt(json['type']),
      startedAt: _toString(json['startedAt']),
      durationInDays: _toInt(json['durationInDays']),
      progressRatio: json['progressRatio'] as num?,
      status: statusJson == null
          ? const PmoStepStatusDto(title: '', titleAr: '', color: '')
          : PmoStepStatusDto.fromJson(statusJson),
    );
  }
}

class PmoProjectDto {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String ownerId;
  final int attachmentsCount;
  final List<String> assignedUsers;
  final int dayesLeft;
  final String brandTitle;
  final String product;
  final String sizeML;
  final String activityTitle;
  final num progress;
  final num expectedProgress;
  final num quantity;
  final List<dynamic> projectTags;
  final int status;
  final int projectType;
  final PmoCurrentStepDto? currentStep;

  const PmoProjectDto({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.ownerId,
    required this.attachmentsCount,
    required this.assignedUsers,
    required this.dayesLeft,
    required this.brandTitle,
    required this.product,
    required this.sizeML,
    required this.activityTitle,
    required this.progress,
    required this.expectedProgress,
    required this.quantity,
    this.projectTags = const [],
    required this.status,
    required this.projectType,
    this.currentStep,
  });

  factory PmoProjectDto.fromJson(Map<String, dynamic> json) {
    final currentStepJson = _toMap(json['currentStep']);
    return PmoProjectDto(
      id: _toString(json['id']),
      title: _toString(json['title']),
      description: _toString(json['description']),
      startDate: _toString(json['startDate']),
      ownerId: _toString(json['ownerId']),
      attachmentsCount: _toInt(json['attachmentsCount']),
      assignedUsers: _toStringList(json['assignedUsers']),
      dayesLeft: _toInt(json['dayesLeft']),
      brandTitle: _toString(json['brandTitle']),
      product: _toString(json['product']),
      sizeML: _toString(json['sizeML']),
      activityTitle: _toString(json['activityTitle']),
      progress: _toNum(json['progress']),
      expectedProgress: _toNum(json['expectedProgress']),
      quantity: _toNum(json['quantity']),
      projectTags: _toDynamicList(json['projectTags']),
      status: _toInt(json['status']),
      projectType: _toInt(json['projectType']),
      currentStep: currentStepJson == null
          ? null
          : PmoCurrentStepDto.fromJson(currentStepJson),
    );
  }
}

class AggregationValueDto {
  final String term;
  final int count;
  final String identifier;

  const AggregationValueDto({
    required this.term,
    required this.count,
    required this.identifier,
  });

  factory AggregationValueDto.fromJson(Map<String, dynamic> json) {
    return AggregationValueDto(
      term: _toString(json['term']),
      count: _toInt(json['count']),
      identifier: json['identifier']?.toString() ?? '',
    );
  }
}

class AggregationGroupDto {
  final String title;
  final List<AggregationValueDto> values;

  const AggregationGroupDto({
    required this.title,
    required this.values,
  });

  factory AggregationGroupDto.fromJson(Map<String, dynamic> json) {
    final valuesJson = json['values'];
    return AggregationGroupDto(
      title: _toString(json['title']),
      values: valuesJson is List
          ? valuesJson
              .map((e) => AggregationValueDto.fromJson(
                    _toMap(e) ?? const {},
                  ))
              .toList()
          : const [],
    );
  }
}

class ProjectSearchResponseDto {
  final List<PmoProjectDto> data;
  final List<AggregationGroupDto> aggregations;
  final int total;

  const ProjectSearchResponseDto({
    required this.data,
    this.aggregations = const [],
    required this.total,
  });

  factory ProjectSearchResponseDto.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    final aggregationsJson = json['aggregations'];
    return ProjectSearchResponseDto(
      data: dataJson is List
          ? dataJson
              .map((e) => PmoProjectDto.fromJson(_toMap(e) ?? const {}))
              .toList()
          : const [],
      aggregations: aggregationsJson is List
          ? aggregationsJson
              .map((e) => AggregationGroupDto.fromJson(
                    _toMap(e) ?? const {},
                  ))
              .toList()
          : const [],
      total: _toInt(json['total']),
    );
  }
}
