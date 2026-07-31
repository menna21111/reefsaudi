enum RequestHistoryStepStatus {
  completed,
  inProgress,
  waiting,
}

class ProjectRequestHistoryItem {
  const ProjectRequestHistoryItem({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.sortIndex,
    required this.progress,
    required this.isApproved,
    required this.date,
    required this.status,
  });

  final String id;
  final String title;
  final String assignedTo;
  final int sortIndex;
  final int progress;
  final bool isApproved;
  final DateTime? date;
  final RequestHistoryStepStatus status;

  bool get hasValidDate =>
      date != null && date!.year > 1900;

  factory ProjectRequestHistoryItem.fromJson(
    Map<String, dynamic> json, {
    required RequestHistoryStepStatus status,
  }) {
    return ProjectRequestHistoryItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      assignedTo: json['assignedTo']?.toString() ?? '',
      sortIndex: _toInt(json['sortIndex']),
      progress: _toInt(json['progress']),
      isApproved: json['isApproved'] == true,
      date: _parseDate(json['date']),
      status: status,
    );
  }
}

List<ProjectRequestHistoryItem> parseProjectRequestHistory(dynamic raw) {
  if (raw is! List) return const [];

  final items = raw
      .whereType<Map<String, dynamic>>()
      .map(
        (json) => ProjectRequestHistoryItem.fromJson(
          json,
          status: RequestHistoryStepStatus.waiting,
        ),
      )
      .toList()
    ..sort((a, b) => a.sortIndex.compareTo(b.sortIndex));

  final firstPendingIndex = items.indexWhere((item) => !item.isApproved);

  return [
    for (var i = 0; i < items.length; i++)
      ProjectRequestHistoryItem(
        id: items[i].id,
        title: items[i].title,
        assignedTo: items[i].assignedTo,
        sortIndex: items[i].sortIndex,
        progress: items[i].progress,
        isApproved: items[i].isApproved,
        date: items[i].date,
        status: items[i].isApproved
            ? RequestHistoryStepStatus.completed
            : i == firstPendingIndex
                ? RequestHistoryStepStatus.inProgress
                : RequestHistoryStepStatus.waiting,
      ),
  ];
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
