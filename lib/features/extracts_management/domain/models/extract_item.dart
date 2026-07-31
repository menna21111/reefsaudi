import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';

enum ExtractStatus { completed, underReview, delayed }

extension ExtractStatusX on ExtractStatus {
  String get label {
    switch (this) {
      case ExtractStatus.completed:
        return 'مكتمل';
      case ExtractStatus.underReview:
        return 'قيد المراجعة';
      case ExtractStatus.delayed:
        return 'متأخر';
    }
  }

  Color get color {
    switch (this) {
      case ExtractStatus.completed:
        return AppColor.kPrimaryColor;
      case ExtractStatus.underReview:
        return AppColor.kGoldColor;
      case ExtractStatus.delayed:
        return AppColor.kRedColor;
    }
  }
}

class ExtractItem {
  final String projectName;
  final String sector;
  final String extractNumber;
  final String value;
  final String extractStatus;
  final String managementStatus;
  final String startDate;
  final String endDate;
  final ExtractStatus status;

  const ExtractItem({
    required this.projectName,
    required this.sector,
    required this.extractNumber,
    required this.value,
    required this.extractStatus,
    required this.managementStatus,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
