import 'dart:convert';

import 'package:intl/intl.dart';

/// Builds DevExtreme `filter` + counts date query params for quality lists.
class ProjectRequestListFilter {
  const ProjectRequestListFilter({
    this.requestType,
    this.fromDate,
    this.toDate,
  });

  final int? requestType;
  final DateTime? fromDate;
  final DateTime? toDate;

  bool get hasListFilter =>
      requestType != null || (fromDate != null && toDate != null);

  bool get hasDateRange => fromDate != null && toDate != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectRequestListFilter &&
        other.requestType == requestType &&
        other.fromDate == fromDate &&
        other.toDate == toDate;
  }

  @override
  int get hashCode => Object.hash(requestType, fromDate, toDate);

  ProjectRequestListFilter copyWith({
    int? requestType,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearRequestType = false,
    bool clearDates = false,
  }) {
    return ProjectRequestListFilter(
      requestType: clearRequestType ? null : requestType ?? this.requestType,
      fromDate: clearDates ? null : fromDate ?? this.fromDate,
      toDate: clearDates ? null : toDate ?? this.toDate,
    );
  }

  /// Example: `[["requestType","=",5]]`
  /// Example: `[["requestDate",">=","..."],["requestDate","<=","..."]]`
  String toDevExtremeFilterJson() {
    final conditions = <List<dynamic>>[];

    if (requestType != null) {
      conditions.add(['requestType', '=', requestType]);
    }

    if (fromDate != null && toDate != null) {
      conditions.add([
        'requestDate',
        '>=',
        _toUtcIso(_startOfDay(fromDate!)),
      ]);
      conditions.add([
        'requestDate',
        '<=',
        _toUtcIso(_startOfNextDay(toDate!)),
      ]);
    }

    if (conditions.isEmpty) return '[]';
    return jsonEncode(conditions);
  }

  /// Counts API: `7/7/2026, 12:00:00 AM`
  String? countsFromDateParam() {
    if (fromDate == null) return null;
    return _formatCountsDate(_startOfDay(fromDate!));
  }

  String? countsToDateParam() {
    if (toDate == null) return null;
    return _formatCountsDate(_startOfDay(toDate!));
  }

  static DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _startOfNextDay(DateTime date) =>
      _startOfDay(date).add(const Duration(days: 1));

  static String _toUtcIso(DateTime local) =>
      local.toUtc().toIso8601String();

  static String _formatCountsDate(DateTime date) =>
      DateFormat('M/d/yyyy, h:mm:ss a', 'en_US').format(date);
}
