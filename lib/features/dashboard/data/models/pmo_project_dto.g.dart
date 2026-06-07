// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pmo_project_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PmoStepStatusDto _$PmoStepStatusDtoFromJson(Map<String, dynamic> json) =>
    PmoStepStatusDto(
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$PmoStepStatusDtoToJson(PmoStepStatusDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'titleAr': instance.titleAr,
      'color': instance.color,
    };

PmoCurrentStepDto _$PmoCurrentStepDtoFromJson(Map<String, dynamic> json) =>
    PmoCurrentStepDto(
      type: (json['type'] as num).toInt(),
      startedAt: json['startedAt'] as String,
      durationInDays: (json['durationInDays'] as num).toInt(),
      progressRatio: json['progressRatio'] as num?,
      status: PmoStepStatusDto.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PmoCurrentStepDtoToJson(PmoCurrentStepDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'startedAt': instance.startedAt,
      'durationInDays': instance.durationInDays,
      'progressRatio': instance.progressRatio,
      'status': instance.status,
    };

PmoProjectDto _$PmoProjectDtoFromJson(Map<String, dynamic> json) =>
    PmoProjectDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      ownerId: json['ownerId'] as String,
      attachmentsCount: (json['attachmentsCount'] as num).toInt(),
      assignedUsers: (json['assignedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dayesLeft: (json['dayesLeft'] as num).toInt(),
      brandTitle: json['brandTitle'] as String,
      product: json['product'] as String,
      sizeML: json['sizeML'] as String,
      activityTitle: json['activityTitle'] as String,
      progress: json['progress'] as num,
      expectedProgress: json['expectedProgress'] as num,
      quantity: json['quantity'] as num,
      projectTags: json['projectTags'] as List<dynamic>? ?? const [],
      status: (json['status'] as num).toInt(),
      projectType: (json['projectType'] as num).toInt(),
      currentStep: json['currentStep'] == null
          ? null
          : PmoCurrentStepDto.fromJson(
              json['currentStep'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PmoProjectDtoToJson(PmoProjectDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate,
      'ownerId': instance.ownerId,
      'attachmentsCount': instance.attachmentsCount,
      'assignedUsers': instance.assignedUsers,
      'dayesLeft': instance.dayesLeft,
      'brandTitle': instance.brandTitle,
      'product': instance.product,
      'sizeML': instance.sizeML,
      'activityTitle': instance.activityTitle,
      'progress': instance.progress,
      'expectedProgress': instance.expectedProgress,
      'quantity': instance.quantity,
      'projectTags': instance.projectTags,
      'status': instance.status,
      'projectType': instance.projectType,
      'currentStep': instance.currentStep,
    };

AggregationValueDto _$AggregationValueDtoFromJson(Map<String, dynamic> json) =>
    AggregationValueDto(
      term: json['term'] as String,
      count: (json['count'] as num).toInt(),
      identifier: AggregationValueDto._identifierFromJson(json['identifier']),
    );

Map<String, dynamic> _$AggregationValueDtoToJson(
  AggregationValueDto instance,
) => <String, dynamic>{
  'term': instance.term,
  'count': instance.count,
  'identifier': AggregationValueDto._identifierToJson(instance.identifier),
};

AggregationGroupDto _$AggregationGroupDtoFromJson(Map<String, dynamic> json) =>
    AggregationGroupDto(
      title: json['title'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => AggregationValueDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AggregationGroupDtoToJson(
  AggregationGroupDto instance,
) => <String, dynamic>{'title': instance.title, 'values': instance.values};

ProjectSearchResponseDto _$ProjectSearchResponseDtoFromJson(
  Map<String, dynamic> json,
) => ProjectSearchResponseDto(
  data: (json['data'] as List<dynamic>)
      .map((e) => PmoProjectDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  aggregations:
      (json['aggregations'] as List<dynamic>?)
          ?.map((e) => AggregationGroupDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$ProjectSearchResponseDtoToJson(
  ProjectSearchResponseDto instance,
) => <String, dynamic>{
  'data': instance.data,
  'aggregations': instance.aggregations,
  'total': instance.total,
};
