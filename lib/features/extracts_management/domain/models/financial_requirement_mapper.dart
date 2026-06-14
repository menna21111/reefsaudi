import '../../../financial_requirements/domain/entities/financial_requirement.dart';
import 'extract_item.dart';

class FinancialRequirementMapper {
  static ExtractItem toExtractItem(FinancialRequirement item) {
    return ExtractItem(
      projectName: item.projectName,
      sector: item.sector,
      extractNumber: item.extractNumber,
      value: item.extractValue,
      extractStatus: item.extractStatus,
      managementStatus: item.projectManagementStatus,
      startDate: item.startDate,
      endDate: item.endDate,
      status: _mapStatus(item.extractStatus),
    );
  }

  static ExtractStatus _mapStatus(String status) {
    final normalized = status.trim();
    if (normalized.contains('مكتمل') ||
        normalized.contains('معتمد') ||
        normalized.toLowerCase().contains('complete')) {
      return ExtractStatus.completed;
    }
    if (normalized.contains('متأخر') ||
        normalized.contains('مرفوض') ||
        normalized.toLowerCase().contains('delay')) {
      return ExtractStatus.delayed;
    }
    return ExtractStatus.underReview;
  }

  static String formatCompactAmount(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
