double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

class ProjectStatusCountsDto {
  final int startedCount;
  final double startedSum;
  final int finishedCount;
  final double finishedSum;
  final int awardedCount;
  final double awardedSum;
  final int tenderCount;
  final double tenderSum;

  const ProjectStatusCountsDto({
    required this.startedCount,
    required this.startedSum,
    required this.finishedCount,
    required this.finishedSum,
    required this.awardedCount,
    required this.awardedSum,
    required this.tenderCount,
    required this.tenderSum,
  });

  factory ProjectStatusCountsDto.fromJson(Map<String, dynamic> json) {
    return ProjectStatusCountsDto(
      startedCount: _toInt(json['startedCount']),
      startedSum: _toDouble(json['startedSum']),
      finishedCount: _toInt(json['finishedCount']),
      finishedSum: _toDouble(json['finishedSum']),
      awardedCount: _toInt(json['awardedCount']),
      awardedSum: _toDouble(json['awardedSum']),
      tenderCount: _toInt(json['tenderCount']),
      tenderSum: _toDouble(json['tenderSum']),
    );
  }
}

class FinancialStatementProjectsDto {
  final int reclaimedTotalCount;
  final double reclaimedTotalSum;
  final double paidAmount;
  final double underStudiesAmount;
  final double remainingAmount;

  const FinancialStatementProjectsDto({
    required this.reclaimedTotalCount,
    required this.reclaimedTotalSum,
    required this.paidAmount,
    required this.underStudiesAmount,
    required this.remainingAmount,
  });

  factory FinancialStatementProjectsDto.fromJson(Map<String, dynamic> json) {
    return FinancialStatementProjectsDto(
      reclaimedTotalCount: _toInt(json['reclaimedTotalCount']),
      reclaimedTotalSum: _toDouble(json['reclaimedTotalSum']),
      paidAmount: _toDouble(json['paidAmount']),
      underStudiesAmount: _toDouble(json['underStudiesAmount']),
      remainingAmount: _toDouble(json['reminingAmount']),
    );
  }

  double get progressTotal =>
      paidAmount + underStudiesAmount + remainingAmount;
}

class ProjectsFinancialSectorsDto {
  final double totalBudget;
  final int projectsCount;
  final double totalProjectsActualBudget;
  final int sectorsCount;

  const ProjectsFinancialSectorsDto({
    required this.totalBudget,
    required this.projectsCount,
    required this.totalProjectsActualBudget,
    required this.sectorsCount,
  });

  factory ProjectsFinancialSectorsDto.fromJson(Map<String, dynamic> json) {
    return ProjectsFinancialSectorsDto(
      totalBudget: _toDouble(json['totalbudget'] ?? json['totalBudget']),
      projectsCount: _toInt(json['projectsCount']),
      totalProjectsActualBudget:
          _toDouble(json['totalProjectsActualbudget'] ??
              json['totalProjectsActualBudget']),
      sectorsCount: _toInt(json['sectorsCount']),
    );
  }
}

class BrandDto {
  final String id;
  final String title;
  final String description;

  const BrandDto({
    required this.id,
    required this.title,
    required this.description,
  });

  factory BrandDto.fromJson(Map<String, dynamic> json) {
    return BrandDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

class BrandsPageDto {
  final List<BrandDto> items;

  const BrandsPageDto({required this.items});

  factory BrandsPageDto.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    if (items is! List) return const BrandsPageDto(items: []);
    return BrandsPageDto(
      items: items
          .whereType<Map<String, dynamic>>()
          .map(BrandDto.fromJson)
          .toList(),
    );
  }
}

class PortfolioOverviewBundle {
  final ProjectsFinancialSectorsDto sectors;
  final ProjectStatusCountsDto statusCounts;
  final FinancialStatementProjectsDto financial;
  final List<BrandDto> brands;
  final String? selectedBrandId;
  final String? selectedBrandTitle;

  const PortfolioOverviewBundle({
    required this.sectors,
    required this.statusCounts,
    required this.financial,
    required this.brands,
    this.selectedBrandId,
    this.selectedBrandTitle,
  });

  PortfolioOverviewBundle copyWith({
    ProjectsFinancialSectorsDto? sectors,
    ProjectStatusCountsDto? statusCounts,
    FinancialStatementProjectsDto? financial,
    List<BrandDto>? brands,
    String? selectedBrandId,
    String? selectedBrandTitle,
    bool clearBrand = false,
  }) {
    return PortfolioOverviewBundle(
      sectors: sectors ?? this.sectors,
      statusCounts: statusCounts ?? this.statusCounts,
      financial: financial ?? this.financial,
      brands: brands ?? this.brands,
      selectedBrandId:
          clearBrand ? null : (selectedBrandId ?? this.selectedBrandId),
      selectedBrandTitle: clearBrand
          ? null
          : (selectedBrandTitle ?? this.selectedBrandTitle),
    );
  }
}
