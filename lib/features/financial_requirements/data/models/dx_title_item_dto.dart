class DxTitleItemDto {
  final String id;
  final String title;
  final String? description;
  final bool? isFinal;

  const DxTitleItemDto({
    required this.id,
    required this.title,
    this.description,
    this.isFinal,
  });

  factory DxTitleItemDto.fromJson(Map<String, dynamic> json) {
    return DxTitleItemDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      isFinal: json['isFinal'] as bool?,
    );
  }
}

List<DxTitleItemDto> parseDxTitleItems(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(DxTitleItemDto.fromJson)
      .toList();
}
