import 'package:flutter/material.dart';
import '../../domain/models/achievement_month_record.dart';
import 'achievement_monthly_record_card.dart';

class AchievementMonthlyRecordsList extends StatelessWidget {
  final List<AchievementMonthRecord> records;

  const AchievementMonthlyRecordsList({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: records
          .map(
            (record) => AchievementMonthlyRecordCard(record: record),
          )
          .toList(),
    );
  }
}
