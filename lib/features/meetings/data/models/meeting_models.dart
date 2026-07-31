import 'dart:convert';

class MeetingAccountOption {
  const MeetingAccountOption({
    required this.id,
    required this.fullName,
  });

  final String id;
  final String fullName;

  factory MeetingAccountOption.fromJson(Map<String, dynamic> json) {
    return MeetingAccountOption(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

List<MeetingAccountOption> parseMeetingAccounts(dynamic raw) {
  if (raw is! List) return [];
  return raw
      .whereType<Map>()
      .map((e) => MeetingAccountOption.fromJson(Map<String, dynamic>.from(e)))
      .where((e) => e.id.isNotEmpty)
      .toList();
}

class MeetingTopic {
  const MeetingTopic({
    this.id,
    required this.title,
    this.description = '',
    this.duration = 0,
    this.sortIndex = 0,
    this.parentId,
    this.presenterId,
    this.presenter = '',
  });

  final String? id;
  final String title;
  final String description;
  final int duration;
  final int sortIndex;
  final String? parentId;
  final String? presenterId;
  final String presenter;

  factory MeetingTopic.fromJson(Map<String, dynamic> json) {
    return MeetingTopic(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      sortIndex: (json['sortIndex'] as num?)?.toInt() ?? 0,
      parentId: json['parentId']?.toString(),
      presenterId: json['presenterId']?.toString(),
      presenter: json['presenter']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null && id!.isNotEmpty) 'id': id,
        'title': title.trim(),
        'description': description.trim(),
        'duration': duration,
        'sortIndex': sortIndex,
        if (parentId != null) 'parentId': parentId,
        if (presenterId != null && presenterId!.isNotEmpty)
          'presenterId': presenterId,
      };

  MeetingTopic copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    int? sortIndex,
    String? parentId,
    String? presenterId,
    String? presenter,
  }) {
    return MeetingTopic(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      sortIndex: sortIndex ?? this.sortIndex,
      parentId: parentId ?? this.parentId,
      presenterId: presenterId ?? this.presenterId,
      presenter: presenter ?? this.presenter,
    );
  }
}

class MeetingItem {
  const MeetingItem({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.location = '',
    this.presenter = '',
    this.employeesIds = const [],
    this.topics = const [],
    this.isPublished = false,
    this.isCreator = false,
  });

  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String location;
  final String presenter;
  final List<String> employeesIds;
  final List<MeetingTopic> topics;
  final bool isPublished;
  final bool isCreator;

  factory MeetingItem.fromJson(Map<String, dynamic> json) {
    final employeesRaw = json['employeesIds'];
    final topicsRaw = json['topics'];

    return MeetingItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate: DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      presenter: json['presenter']?.toString() ?? '',
      employeesIds: employeesRaw is List
          ? employeesRaw.map((e) => e.toString()).toList()
          : const [],
      topics: topicsRaw is List
          ? topicsRaw
              .whereType<Map>()
              .map((e) => MeetingTopic.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      isPublished: json['isPublished'] == true,
      isCreator: json['isCreator'] == true,
    );
  }
}

class MeetingsListResponse {
  const MeetingsListResponse({
    required this.data,
    this.totalCount = 0,
  });

  final List<MeetingItem> data;
  final int totalCount;

  factory MeetingsListResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final items = raw is List
        ? raw
            .whereType<Map>()
            .map((e) => MeetingItem.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <MeetingItem>[];

    return MeetingsListResponse(
      data: items,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? items.length,
    );
  }
}

class MeetingWriteRequest {
  const MeetingWriteRequest({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.location = '',
    this.employeesIds = const [],
    this.topics = const [],
    this.isPublished = false,
  });

  final String? id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String location;
  final List<String> employeesIds;
  final List<MeetingTopic> topics;
  final bool isPublished;

  Map<String, dynamic> toJson() => {
        if (id != null && id!.isNotEmpty) 'id': id,
        'title': title.trim(),
        'description': description.trim(),
        'startDate': toIsoLocal(startDate),
        'endDate': toIsoLocal(endDate),
        'location': location.trim(),
        'employeesIds': employeesIds,
        'topics': topics.map((t) => t.toJson()).toList(),
        'isPublished': isPublished,
      };

  static String toIsoLocal(DateTime date) {
    final local = DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
    );
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    final s = local.second.toString().padLeft(2, '0');
    return '$y-$m-$d'
        'T$h:$min:$s';
  }
}

/// Builds the DevExtreme filter used by the web meetings calendar.
abstract final class MeetingsFilterBuilder {
  static String forRange(DateTime rangeStart, DateTime rangeEnd) {
    final startIso = _dateOnlyIso(rangeStart);
    final endIso = _dateOnlyIso(rangeEnd);

    final filter = [
      [
        [
          [
            ['endDate', '>=', startIso],
            ['startDate', '<', endIso],
          ],
          'or',
          ['title', 'startswith', 'freq'],
          'or',
          [
            ['endDate', startIso],
            ['startDate', startIso],
          ],
        ],
      ],
    ];

    return jsonEncode(filter);
  }

  static String _dateOnlyIso(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d'
        'T00:00:00';
  }
}
