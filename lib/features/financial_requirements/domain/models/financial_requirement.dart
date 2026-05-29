enum FinancialRequirementStatus { all, funded, unfunded, completed }

class FinancialRequirement {
  final String id;
  final String projectName;
  final String projectNumber;
  final String amount;
  final String date;
  final String contractor;
  final FinancialRequirementStatus status;
  final double progressPercent;

  const FinancialRequirement({
    required this.id,
    required this.projectName,
    required this.projectNumber,
    required this.amount,
    required this.date,
    required this.contractor,
    required this.status,
    required this.progressPercent,
  });
}

final List<FinancialRequirement> mockFinancialRequirements = [
  FinancialRequirement(
    id: 'FIN-001',
    projectName: 'توريد وتركيب أجهزة وحدة الصادر المتطورة',
    projectNumber: 'PRJ-2024-001',
    amount: '2.03M',
    date: '12/09/2024',
    contractor: 'بن مرشد',
    status: FinancialRequirementStatus.funded,
    progressPercent: 0.75,
  ),
  FinancialRequirement(
    id: 'FIN-002',
    projectName: 'تقديم الدعم الاستشاري لتنفيذ قدس المقدس بالمدينة الذكية',
    projectNumber: 'PRJ-2024-002',
    amount: '1.88M',
    date: '29/02/2024',
    contractor: 'المشرق للتطوير',
    status: FinancialRequirementStatus.unfunded,
    progressPercent: 0.45,
  ),
  FinancialRequirement(
    id: 'FIN-003',
    projectName: 'صيانة شبكة الرووب والطاقات الشمسية للمدارس والمزارع',
    projectNumber: 'PRJ-2025-001',
    amount: '0.27M',
    date: '21/09/2025',
    contractor: 'الريف الأخضر',
    status: FinancialRequirementStatus.completed,
    progressPercent: 1.0,
  ),
  FinancialRequirement(
    id: 'FIN-004',
    projectName: 'إنشاء محطة تحلية المياه الجوفية في المنطقة الشرقية',
    projectNumber: 'PRJ-2024-004',
    amount: '5.14M',
    date: '05/11/2024',
    contractor: 'شركة المياه الوطنية',
    status: FinancialRequirementStatus.funded,
    progressPercent: 0.60,
  ),
  FinancialRequirement(
    id: 'FIN-005',
    projectName: 'تطوير منظومة الري الذكي في المزارع الكبرى',
    projectNumber: 'PRJ-2025-003',
    amount: '3.75M',
    date: '18/03/2025',
    contractor: 'تقنيات الزراعة الحديثة',
    status: FinancialRequirementStatus.unfunded,
    progressPercent: 0.30,
  ),
];
