class SupplierDxItemDto {
  final String id;
  final String title;
  final int type;

  const SupplierDxItemDto({
    required this.id,
    required this.title,
    required this.type,
  });

  factory SupplierDxItemDto.fromJson(Map<String, dynamic> json) {
    return SupplierDxItemDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: _toInt(json['type']),
    );
  }
}

List<SupplierDxItemDto> parseSupplierDxItems(dynamic raw) {
  if (raw is! List) return [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(SupplierDxItemDto.fromJson)
      .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
      .toList();
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
