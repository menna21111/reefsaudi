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

  const CreateFinancialStatementRequest({
    required this.projectId,
    this.statementNo,
    required this.amount,
    this.description,
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
      if (sector != null && sector!.trim().isNotEmpty) 'sector': sector!.trim(),
      'financialStatusId': financialStatusId,
      'pmStatusId': pmStatusId,
      if (startDate != null) 'startDate': startDate!.toUtc().toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toUtc().toIso8601String(),
    };
  }
}
