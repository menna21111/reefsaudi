import 'package:json_annotation/json_annotation.dart';

part 'pmo_project_dto.g.dart';

@JsonSerializable()
class PmoStepStatusDto {
  final String title;
  final String titleAr;
  final String color;

  const PmoStepStatusDto({
    required this.title,
    required this.titleAr,
    required this.color,
  });

  factory PmoStepStatusDto.fromJson(Map<String, dynamic> json) =>
      _$PmoStepStatusDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PmoStepStatusDtoToJson(this);
}

@JsonSerializable()
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

  factory PmoCurrentStepDto.fromJson(Map<String, dynamic> json) =>
      _$PmoCurrentStepDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PmoCurrentStepDtoToJson(this);
}

@JsonSerializable()
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

  factory PmoProjectDto.fromJson(Map<String, dynamic> json) =>
      _$PmoProjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PmoProjectDtoToJson(this);
}

@JsonSerializable()
class AggregationValueDto {
  final String term;
  final int count;
  @JsonKey(fromJson: _identifierFromJson, toJson: _identifierToJson)
  final String identifier;

  const AggregationValueDto({
    required this.term,
    required this.count,
    required this.identifier,
  });

  factory AggregationValueDto.fromJson(Map<String, dynamic> json) =>
      _$AggregationValueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AggregationValueDtoToJson(this);

  static String _identifierFromJson(dynamic value) => value?.toString() ?? '';
  static dynamic _identifierToJson(String value) => value;
}

@JsonSerializable()
class AggregationGroupDto {
  final String title;
  final List<AggregationValueDto> values;

  const AggregationGroupDto({
    required this.title,
    required this.values,
  });

  factory AggregationGroupDto.fromJson(Map<String, dynamic> json) =>
      _$AggregationGroupDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AggregationGroupDtoToJson(this);
}

@JsonSerializable()
class ProjectSearchResponseDto {
  final List<PmoProjectDto> data;
  final List<AggregationGroupDto> aggregations;
  final int total;

  const ProjectSearchResponseDto({
    required this.data,
    this.aggregations = const [],
    required this.total,
  });

  factory ProjectSearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectSearchResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectSearchResponseDtoToJson(this);
}
