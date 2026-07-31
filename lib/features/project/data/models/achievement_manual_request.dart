import 'dart:convert';

import 'package:dio/dio.dart';

class CreateAchievementManualRequest {
  const CreateAchievementManualRequest({
    required this.projectId,
    required this.monthYear,
    required this.planned,
    required this.actual,
  });

  final String projectId;
  final String monthYear;
  final double planned;
  final double actual;

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'monthYear': monthYear,
        'planned': achievementJsonNumber(planned),
        'actual': achievementJsonNumber(actual),
      };

  FormData toFormData() {
    return FormData.fromMap({
      'values': jsonEncode(toJson()),
    });
  }
}

class UpdateAchievementManualRequest {
  const UpdateAchievementManualRequest({
    required this.key,
    required this.projectId,
    required this.monthYear,
    required this.planned,
    required this.actual,
  });

  final String key;
  final String projectId;
  final String monthYear;
  final double planned;
  final double actual;

  Map<String, dynamic> toValuesJson() => {
        'projectId': projectId,
        'monthYear': monthYear,
        'planned': achievementJsonNumber(planned),
        'actual': achievementJsonNumber(actual),
      };

  FormData toFormData() {
    return FormData.fromMap({
      'key': key,
      'values': jsonEncode(toValuesJson()),
    });
  }
}

num achievementJsonNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt();
  }
  return value;
}

/// API expects `2026-07-02T00:00:00` (no timezone suffix / milliseconds).
String formatAchievementMonthYear(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-${day}T00:00:00';
}
