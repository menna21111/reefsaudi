import '../../domain/entities/financial_requirement.dart';
import 'project_nested_model.dart';
import 'status_model.dart';

class FinancialStatementModel {
  final String? id;
  final int? statementNo;
  final String? startDate;
  final String? endDate;
  final double? amount;
  final String? description;
  final String? sector;
  final StatusModel? pmStatus;
  final StatusModel? financialStatus;
  final ProjectNestedModel? project;

  const FinancialStatementModel({
    this.id,
    this.statementNo,
    this.startDate,
    this.endDate,
    this.amount,
    this.description,
    this.sector,
    this.pmStatus,
    this.financialStatus,
    this.project,
  });

  factory FinancialStatementModel.fromJson(Map<String, dynamic> json) {
    return FinancialStatementModel(
      id: json['id'] as String?,
      statementNo: json['statementNo'] as int?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      sector: json['sector'] as String?,
      pmStatus: StatusModel.fromJson(
        json['pmStatus'] as Map<String, dynamic>?,
      ),
      financialStatus: StatusModel.fromJson(
        json['financialStatus'] as Map<String, dynamic>?,
      ),
      project: ProjectNestedModel.fromJson(
        json['project'] as Map<String, dynamic>?,
      ),
    );
  }

  FinancialRequirement toEntity() {
    return FinancialRequirement(
      id: id ?? '',
      projectName: project?.title?.trim() ?? '-',
      sector: sector ?? '-',
      extractNumber: '${statementNo ?? 0}',
      extractValue: _formatAmount(amount),
      extractStatus: financialStatus?.title ?? '-',
      projectManagementStatus: pmStatus?.title ?? '-',
      startDate: _formatDate(startDate),
      endDate: _formatDate(endDate),
      amount: amount ?? 0,
    );
  }

  static String _formatAmount(double? value) {
    if (value == null) return '-';
    final parts = value.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    final buffer = StringBuffer();
    for (var i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(integerPart[i]);
    }

    if (decimalPart != '00') {
      buffer.write('.');
      buffer.write(decimalPart);
    }

    return buffer.toString();
  }

  static String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.year}/${date.month}/${date.day}';
    } catch (_) {
      return isoDate;
    }
  }
}
