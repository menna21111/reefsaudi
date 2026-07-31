class ProjectRequestAttachmentItem {
  const ProjectRequestAttachmentItem({
    required this.id,
    required this.name,
    required this.isDirectory,
    required this.parentName,
    required this.attachmentPath,
    required this.date,
    required this.size,
  });

  final String id;
  final String name;
  final bool isDirectory;
  final String parentName;
  final String attachmentPath;
  final DateTime? date;
  final int size;

  bool get isPdf => name.toLowerCase().endsWith('.pdf');

  bool get isImage {
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }

  bool get isPreviewable => isPdf || isImage;

  bool get isOpenable => attachmentPath.trim().isNotEmpty;

  factory ProjectRequestAttachmentItem.fromJson(Map<String, dynamic> json) {
    return ProjectRequestAttachmentItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isDirectory: json['isDirectory'] == true,
      parentName: json['parentName']?.toString() ?? '',
      attachmentPath: json['attachmentPath']?.toString() ?? '',
      date: _parseDate(json['date']),
      size: _toInt(json['size']),
    );
  }
}

List<ProjectRequestAttachmentItem> parseProjectRequestAttachments(dynamic raw) {
  if (raw is! List) return const [];

  return raw
      .whereType<Map<String, dynamic>>()
      .map(ProjectRequestAttachmentItem.fromJson)
      .where((item) => item.id.isNotEmpty && !item.isDirectory)
      .toList();
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
