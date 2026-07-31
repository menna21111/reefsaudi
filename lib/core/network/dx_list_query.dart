import 'dart:convert';

abstract final class DxListQuery {
  static Map<String, dynamic> paged({
    required int skip,
    required int take,
    String? searchText,
    List<String> searchFields = const ['title', 'description', 'id'],
  }) {
    final query = <String, dynamic>{
      'skip': skip,
      'take': take,
      'requireTotalCount': true,
      '_': DateTime.now().millisecondsSinceEpoch,
    };

    final trimmedSearch = searchText?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      query['filter'] = buildContainsFilter(
        fields: searchFields,
        value: trimmedSearch,
      );
    }

    return query;
  }

  static String buildContainsFilter({
    required List<String> fields,
    required String value,
  }) {
    final escaped = value.replaceAll('"', r'\"');
    final clauses = <dynamic>[];

    for (var index = 0; index < fields.length; index++) {
      if (index > 0) clauses.add('or');
      clauses.add([fields[index], 'contains', escaped]);
    }

    return jsonEncode(clauses);
  }
}
