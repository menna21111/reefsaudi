class ProjectRequestStatusCounts {
  const ProjectRequestStatusCounts({
    required this.inprogressCount,
    required this.approvedCount,
    required this.approvedWithCommentCount,
    required this.resubmittedCount,
    required this.rejectedCount,
    required this.delayedCount,
  });

  final int inprogressCount;
  final int approvedCount;
  final int approvedWithCommentCount;
  final int resubmittedCount;
  final int rejectedCount;
  final int delayedCount;

  factory ProjectRequestStatusCounts.fromJson(Map<String, dynamic> json) {
    return ProjectRequestStatusCounts(
      inprogressCount: _toInt(json['inprogressCount']),
      approvedCount: _toInt(json['approvedCount']),
      approvedWithCommentCount: _toInt(json['approvedWithCommentCount']),
      resubmittedCount: _toInt(json['resubmittedCount']),
      rejectedCount: _toInt(json['rejectedCount']),
      delayedCount: _toInt(json['delayedCount']),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}
