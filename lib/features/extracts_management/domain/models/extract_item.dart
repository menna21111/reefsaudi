import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';

enum ExtractStatus {
  completed,
  underReview,
  delayed,
}

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
  final String sector;
  final String extractNumber;
  final String value;
  final ExtractStatus status;
  final String managementStatus;

  const ExtractItem({
    required this.sector,
    required this.extractNumber,
    required this.value,
    required this.status,
    required this.managementStatus,
  });
}

const mockExtractItems = [
  ExtractItem(
    sector: 'الفاكهة',
    extractNumber: 'EXT-2024-001',
    value: '12.4M',
    status: ExtractStatus.completed,
    managementStatus: 'معتمد',
  ),
  ExtractItem(
    sector: 'الخضروات',
    extractNumber: 'EXT-2024-015',
    value: '5.2M',
    status: ExtractStatus.underReview,
    managementStatus: 'تحت الإجراء',
  ),
  ExtractItem(
    sector: 'التمور',
    extractNumber: 'EXT-2024-042',
    value: '8.8M',
    status: ExtractStatus.delayed,
    managementStatus: 'مرفوض',
  ),
  ExtractItem(
    sector: 'الماشية',
    extractNumber: 'EXT-2024-089',
    value: '15.1M',
    status: ExtractStatus.completed,
    managementStatus: 'معتمد',
  ),
];
