import '../../../financial_requirements/domain/entities/financial_requirement.dart';
import 'extract_item.dart';

class FinancialRequirementMapper {
  static ExtractItem toExtractItem(FinancialRequirement item) {
    return ExtractItem(
      sector: item.sector,
      extractNumber: item.extractNumber,
      value: item.extractValue,
      status: _mapStatus(item.extractStatus),
      managementStatus: item.projectManagementStatus,
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
