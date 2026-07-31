class FinancialStatementSummary {
  const FinancialStatementSummary({
    required this.totalAmount,
    required this.paidAmount,
    required this.inProgressAmount,
  });

  final double totalAmount;
  final double paidAmount;
  final double inProgressAmount;

  factory FinancialStatementSummary.fromJson(Map<String, dynamic> json) {
    return FinancialStatementSummary(
      totalAmount: _toDouble(json['totalAmount']),
      paidAmount: _toDouble(json['paidAmount']),
      inProgressAmount: _toDouble(json['inProgressAmount']),
    );
  }

  static const empty = FinancialStatementSummary(
    totalAmount: 0,
    paidAmount: 0,
    inProgressAmount: 0,
  );

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
