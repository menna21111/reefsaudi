class ProjectRequestSummaryItem {
  const ProjectRequestSummaryItem({
    required this.requestType,
    required this.requestTypeName,
    required this.inProgress,
    required this.accepted,
    required this.rejected,
    required this.reRequest,
    required this.haveNote,
  });

  final int requestType;
  final String requestTypeName;
  final int inProgress;
  final int accepted;
  final int rejected;
  final int reRequest;
  final int haveNote;

  int get totalProcessed => accepted + inProgress + reRequest + rejected + haveNote;

  factory ProjectRequestSummaryItem.fromJson(Map<String, dynamic> json) {
    return ProjectRequestSummaryItem(
      requestType: _toInt(json['requestType']),
      requestTypeName: json['requestTypeName']?.toString() ?? '',
      inProgress: _toInt(json['inProgress']),
      accepted: _toInt(json['accepted']),
      rejected: _toInt(json['rejected']),
      reRequest: _toInt(json['reRequest']),
      haveNote: _toInt(json['haveNote']),
    );
  }
}

class ProjectRequestSummaryResponse {
  const ProjectRequestSummaryResponse({
    required this.data,
    required this.totalCount,
    required this.groupCount,
  });

  final List<ProjectRequestSummaryItem> data;
  final int totalCount;
  final int groupCount;

  int get processedTotal =>
      data.fold<int>(0, (sum, item) => sum + item.totalProcessed);

  factory ProjectRequestSummaryResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return ProjectRequestSummaryResponse(
      data: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(ProjectRequestSummaryItem.fromJson)
              .toList()
          : const [],
      totalCount: _toInt(json['totalCount']),
      groupCount: _toInt(json['groupCount']),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}
