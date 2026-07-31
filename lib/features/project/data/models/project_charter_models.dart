import 'dart:convert';

import 'package:dio/dio.dart';

class ProjectCharterDetailsDto {
  const ProjectCharterDetailsDto({
    required this.id,
    this.scopeOfWork,
    this.outOfScopeOfWork,
    this.description,
    this.totalCost = 0,
    this.duration = 0,
    this.startDate,
    this.endDate,
  });

  final String id;
  final String? scopeOfWork;
  final String? outOfScopeOfWork;
  final String? description;
  final double totalCost;
  final int duration;
  final String? startDate;
  final String? endDate;

  factory ProjectCharterDetailsDto.fromJson(Map<String, dynamic> json) {
    return ProjectCharterDetailsDto(
      id: json['id']?.toString() ?? '',
      scopeOfWork: json['scopeOfWork']?.toString(),
      outOfScopeOfWork: json['outOfScopeOfWork']?.toString(),
      description: json['description']?.toString(),
      totalCost: _toDouble(json['totalCost']),
      duration: _toInt(json['duration']),
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
    );
  }
}

class CharterAchievementDto {
  const CharterAchievementDto({required this.id, required this.title});

  final String id;
  final String title;

  factory CharterAchievementDto.fromJson(Map<String, dynamic> json) {
    return CharterAchievementDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}

class CharterStageDto {
  const CharterStageDto({
    required this.id,
    required this.title,
    required this.planned,
    required this.actual,
    this.date,
  });

  final String id;
  final String title;
  final double planned;
  final double actual;
  final String? date;

  factory CharterStageDto.fromJson(Map<String, dynamic> json) {
    return CharterStageDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      planned: _toDouble(json['planned']),
      actual: _toDouble(json['actual']),
      date: json['date']?.toString(),
    );
  }
}

class CharterConstraintDto {
  const CharterConstraintDto({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  factory CharterConstraintDto.fromJson(Map<String, dynamic> json) {
    return CharterConstraintDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

class CharterAttachmentDto {
  const CharterAttachmentDto({
    required this.id,
    required this.name,
    required this.size,
    required this.path,
    this.date,
    this.creator,
  });

  final String id;
  final String name;
  final int size;
  final String path;
  final String? date;
  final String? creator;

  factory CharterAttachmentDto.fromJson(Map<String, dynamic> json) {
    return CharterAttachmentDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      size: _toInt(json['size']),
      path: json['path']?.toString() ?? '',
      date: json['date']?.toString(),
      creator: json['creator']?.toString(),
    );
  }
}

class CharterTextWriteRequest {
  const CharterTextWriteRequest({
    this.id,
    required this.title,
  });

  final String? id;
  final String title;

  Map<String, dynamic> toValuesJson() => {
        'title': title.trim(),
      };

  FormData toCreateFormData() {
    return FormData.fromMap({
      'values': jsonEncode(toValuesJson()),
    });
  }

  FormData toUpdateFormData() {
    return FormData.fromMap({
      if (id != null && id!.trim().isNotEmpty) 'key': id!.trim(),
      'values': jsonEncode(toValuesJson()),
    });
  }
}

class CharterConstraintWriteRequest {
  const CharterConstraintWriteRequest({
    this.id,
    required this.title,
    required this.description,
  });

  final String? id;
  final String title;
  final String description;

  Map<String, dynamic> toValuesJson() => {
        'title': title.trim(),
        'description': description.trim(),
      };

  FormData toCreateFormData() {
    return FormData.fromMap({
      'values': jsonEncode(toValuesJson()),
    });
  }

  FormData toUpdateFormData() {
    return FormData.fromMap({
      if (id != null && id!.trim().isNotEmpty) 'key': id!.trim(),
      'values': jsonEncode(toValuesJson()),
    });
  }
}

class CharterStageWriteRequest {
  const CharterStageWriteRequest({
    this.id,
    required this.title,
    required this.planned,
    required this.actual,
  });

  final String? id;
  final String title;
  final double planned;
  final double actual;

  Map<String, dynamic> toCreateValuesJson() => {
        'title': title.trim(),
        'planned': _charterNumber(planned),
        'actual': _charterNumber(actual),
      };

  Map<String, dynamic> toUpdateValuesJson() => {
        'title': title.trim(),
      };

  FormData toCreateFormData() {
    return FormData.fromMap({
      'values': jsonEncode(toCreateValuesJson()),
    });
  }

  FormData toUpdateFormData() {
    return FormData.fromMap({
      if (id != null && id!.trim().isNotEmpty) 'key': id!.trim(),
      'values': jsonEncode(toUpdateValuesJson()),
    });
  }
}

class CharterPagedResponse<T> {
  const CharterPagedResponse({
    required this.data,
    required this.totalCount,
  });

  final List<T> data;
  final int totalCount;

  factory CharterPagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return CharterPagedResponse(
      data: _parseList(json['data'], fromJsonT),
      totalCount: _toInt(json['totalCount']),
    );
  }
}

class ProjectCharterBundle {
  const ProjectCharterBundle({
    required this.achievements,
    required this.achievementsTotal,
    required this.stages,
    required this.stagesTotal,
    required this.constraints,
    required this.constraintsTotal,
    required this.attachments,
  });

  final List<CharterAchievementDto> achievements;
  final int achievementsTotal;
  final List<CharterStageDto> stages;
  final int stagesTotal;
  final List<CharterConstraintDto> constraints;
  final int constraintsTotal;
  final List<CharterAttachmentDto> attachments;
}

enum CharterSectionStatus { initial, loading, loaded, error }

class CharterSectionState<T> {
  const CharterSectionState({
    this.status = CharterSectionStatus.initial,
    this.items = const [],
    this.totalCount = 0,
    this.errorMessage,
  });

  final CharterSectionStatus status;
  final List<T> items;
  final int totalCount;
  final String? errorMessage;

  bool get isLoading => status == CharterSectionStatus.loading;

  CharterSectionState<T> copyWith({
    CharterSectionStatus? status,
    List<T>? items,
    int? totalCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CharterSectionState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

List<T> _parseList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (raw is! List) return [];
  return raw
      .where((item) => item is Map)
      .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
      .toList();
}

Map<String, dynamic>? _unwrapCharterBody(dynamic raw) {
  if (raw is String && raw.trim().isNotEmpty) {
    try {
      return _unwrapCharterBody(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

dynamic _extractCharterDataList(Map<String, dynamic> body) {
  for (final key in const ['data', 'Data', 'items', 'Items', 'result', 'Result']) {
    final value = body[key];
    if (value is List) return value;
    if (value is Map) {
      final nested = _extractCharterDataList(Map<String, dynamic>.from(value));
      if (nested != null) return nested;
    }
  }
  return null;
}

CharterPagedResponse<T> parseCharterPagedResponse<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJsonT,
) {
  final body = _unwrapCharterBody(raw);
  if (body != null) {
    final data = _parseList(_extractCharterDataList(body), fromJsonT);
    final totalCount = _toInt(body['totalCount'] ?? body['TotalCount']);
    return CharterPagedResponse(
      data: data,
      totalCount: totalCount > 0 ? totalCount : data.length,
    );
  }

  if (raw is List && raw.isNotEmpty && raw.first is Map) {
    final data = _parseList(raw, fromJsonT);
    return CharterPagedResponse(data: data, totalCount: data.length);
  }

  return CharterPagedResponse<T>(data: const [], totalCount: 0);
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

List<CharterAttachmentDto> parseCharterAttachments(dynamic raw) {
  if (raw is List) {
    return _parseList(raw, CharterAttachmentDto.fromJson);
  }
  if (raw is Map) {
    return parseCharterPagedResponse(
      raw,
      CharterAttachmentDto.fromJson,
    ).data;
  }
  return [];
}

Map<String, dynamic> charterSearchQuery(String? search) {
  final trimmed = search?.trim() ?? '';
  return {
    'skip': 0,
    'take': 10,
    'requireTotalCount': true,
    if (trimmed.isNotEmpty) 'filter': '["title","contains","$trimmed"]',
    '_': DateTime.now().millisecondsSinceEpoch,
  };
}

num _charterNumber(double value) {
  if (value == value.roundToDouble()) return value.toInt();
  return value;
}
