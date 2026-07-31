import 'package:dio/dio.dart';

class CreateFinancialStatementRequest {
  final String projectId;
  final int? statementNo;
  final double amount;
  final String? description;
  final String? sector;
  final String financialStatusId;
  final String pmStatusId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? id;
  final String? title;

  const CreateFinancialStatementRequest({
    required this.projectId,
    this.statementNo,
    required this.amount,
    this.description,
    this.title,
    this.sector,
    required this.financialStatusId,
    required this.pmStatusId,
    this.startDate,
    this.endDate,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null && id!.isNotEmpty) 'id': id,
      'projectId': projectId,
      if (statementNo != null) 'statementNo': statementNo,
      'amount': amount,
      if (description != null && description!.trim().isNotEmpty)
        'description': description!.trim(),
      'Title': title,
      if (sector != null && sector!.trim().isNotEmpty) 'sector': sector!.trim(),
      'financialStatusId': financialStatusId,
      'pmStatusId': pmStatusId,
      if (startDate != null) 'startDate': startDate!.toUtc().toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toUtc().toIso8601String(),
    };
  }

  FormData toFormData() {
    return FormData.fromMap({
      'projectId': projectId,
      'financialStatusId': financialStatusId,
      if (startDate != null) 'startDate': _formatDate(startDate!),
      if (description != null && description!.trim().isNotEmpty)
        'description': description!.trim(),
      'amount': amount,
      'pmStatusId': pmStatusId,
      if (endDate != null) 'endDate': _formatDate(endDate!),
    });
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-${day}T00:00:00';
  }
}
