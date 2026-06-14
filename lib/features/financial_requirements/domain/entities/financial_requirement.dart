class FinancialRequirement {
  final String id;
  final String projectName;
  final String sector;
  final String extractNumber;
  final String extractValue;
  final String extractStatus;
  final String projectManagementStatus;
  final String startDate;
  final String endDate;
  final double amount;
  final String regionTitle;
  final String regionId;

  const FinancialRequirement({
    required this.id,
    required this.projectName,
    required this.sector,
    required this.extractNumber,
    required this.extractValue,
    required this.extractStatus,
    required this.projectManagementStatus,
    required this.startDate,
    required this.endDate,
    this.amount = 0,
    this.regionTitle = '',
    this.regionId = '',
  });
}
