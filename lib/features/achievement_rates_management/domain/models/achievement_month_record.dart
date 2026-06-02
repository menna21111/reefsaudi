import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';

class AchievementMonthRecord {
  final String monthLabel;
  final int plannedPercent;
  final int actualPercent;

  const AchievementMonthRecord({
    required this.monthLabel,
    required this.plannedPercent,
    required this.actualPercent,
  });

  double get progressValue => actualPercent / 100;

  Color get progressColor {
    if (actualPercent >= 70) return AppColor.kPrimaryColor;
    if (actualPercent >= 50) return AppColor.kGoldColor;
    return AppColor.kRedColor;
  }
}

const achievementCurrentStatus = (
  periodLabel: 'الحالة الراهنة - مارس ٢٠٢٦',
  completedLabel: '٧٥٪ مكتمل',
  planGapLabel: '٢٠٪ عن المخطط',
  plannedPercent: 77,
  actualPercent: 75,
);

const mockAchievementMonthRecords = [
  AchievementMonthRecord(
    monthLabel: 'مارس، ٢٠٢٦',
    plannedPercent: 77,
    actualPercent: 75,
  ),
  AchievementMonthRecord(
    monthLabel: 'فبراير، ٢٠٢٦',
    plannedPercent: 77,
    actualPercent: 75,
  ),
  AchievementMonthRecord(
    monthLabel: 'ديسمبر، ٢٠٢٥',
    plannedPercent: 62,
    actualPercent: 60,
  ),
  AchievementMonthRecord(
    monthLabel: 'أغسطس، ٢٠٢٥',
    plannedPercent: 37,
    actualPercent: 35,
  ),
];

const achievementChartValues = [80.0, 75.0, 75.0, 60.0, 35.0];
