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

class GeneralStatisticsDto {
  final int projectsCount;
  final double totalBudget;
  final double paidAmount;
  final double inProgressAmount;
  final double contractualBudget;
  final double remaining;

  const GeneralStatisticsDto({
    required this.projectsCount,
    required this.totalBudget,
    required this.paidAmount,
    required this.inProgressAmount,
    required this.contractualBudget,
    required this.remaining,
  });

  factory GeneralStatisticsDto.fromJson(Map<String, dynamic> json) {
    return GeneralStatisticsDto(
      projectsCount: _toInt(json['projectsCount']),
      totalBudget: _toDouble(json['totalBudget']),
      paidAmount: _toDouble(json['paidAmount']),
      inProgressAmount: _toDouble(json['inProgressAmount']),
      contractualBudget: _toDouble(json['contractualBudget']),
      remaining: _toDouble(json['remaining']),
    );
  }
}

class ProjectExecutionSummaryDto {
  final int totalProjects;
  final int finishedProjects;
  final int achievement95Projects;
  final int achievement25Projects;
  final double finishedPercentage;
  final double achievement95Percentage;
  final double achievement25Percentage;

  const ProjectExecutionSummaryDto({
    required this.totalProjects,
    required this.finishedProjects,
    required this.achievement95Projects,
    required this.achievement25Projects,
    required this.finishedPercentage,
    required this.achievement95Percentage,
    required this.achievement25Percentage,
  });

  factory ProjectExecutionSummaryDto.fromJson(Map<String, dynamic> json) {
    return ProjectExecutionSummaryDto(
      totalProjects: _toInt(json['totalProjects']),
      finishedProjects: _toInt(json['finishedProjects']),
      achievement95Projects: _toInt(json['achievement95Projects']),
      achievement25Projects: _toInt(json['achievement25Projects']),
      finishedPercentage: _toDouble(json['finishedPercentage']),
      achievement95Percentage: _toDouble(json['achievement95Percentage']),
      achievement25Percentage: _toDouble(json['achievement25Percentage']),
    );
  }

  int get otherProjects {
    final rest = totalProjects -
        finishedProjects -
        achievement95Projects -
        achievement25Projects;
    return rest > 0 ? rest : 0;
  }
}

class AreaProjectDto {
  final String id;
  final String? regionCode;
  final String title;
  final int count;

  const AreaProjectDto({
    required this.id,
    required this.regionCode,
    required this.title,
    required this.count,
  });

  factory AreaProjectDto.fromJson(Map<String, dynamic> json) {
    return AreaProjectDto(
      id: json['id']?.toString() ?? '',
      regionCode: json['regionCode']?.toString(),
      title: json['title']?.toString() ?? '',
      count: _toInt(json['count']),
    );
  }
}

class SectorProjectDto {
  final String id;
  final String? regionCode;
  final String title;
  final int count;

  const SectorProjectDto({
    required this.id,
    required this.regionCode,
    required this.title,
    required this.count,
  });

  factory SectorProjectDto.fromJson(Map<String, dynamic> json) {
    return SectorProjectDto(
      id: json['id']?.toString() ?? '',
      regionCode: json['regionCode']?.toString(),
      title: json['title']?.toString() ?? '',
      count: _toInt(json['count']),
    );
  }
}

class GlobalQcCategoryDto {
  final String category;
  final double statementsCount;

  const GlobalQcCategoryDto({
    required this.category,
    required this.statementsCount,
  });

  factory GlobalQcCategoryDto.fromJson(Map<String, dynamic> json) {
    return GlobalQcCategoryDto(
      category: json['category']?.toString() ?? '',
      statementsCount: _toDouble(json['statementsCount']),
    );
  }
}

class StatisticsKeyValueDto {
  final String key;
  final int value;

  const StatisticsKeyValueDto({
    required this.key,
    required this.value,
  });

  factory StatisticsKeyValueDto.fromJson(Map<String, dynamic> json) {
    return StatisticsKeyValueDto(
      key: json['key']?.toString() ?? '',
      value: _toInt(json['value']),
    );
  }
}

List<StatisticsKeyValueDto> parseStatisticsKeyValues(dynamic data) {
  if (data is! Map<String, dynamic>) return const [];
  final values = data['values'];
  if (values is! List) return const [];
  return values
      .whereType<Map<String, dynamic>>()
      .map(StatisticsKeyValueDto.fromJson)
      .toList();
}

class GlobalStatisticsBundle {
  final GeneralStatisticsDto general;
  final ProjectExecutionSummaryDto execution;
  final List<AreaProjectDto> areas;
  final List<SectorProjectDto> sectors;
  final List<GlobalQcCategoryDto> qcTechnical;
  final List<StatisticsKeyValueDto> projectStatusCounts;
  final List<StatisticsKeyValueDto> countByType;
  final String? selectedRegionId;
  final String? selectedRegionTitle;

  const GlobalStatisticsBundle({
    required this.general,
    required this.execution,
    required this.areas,
    this.sectors = const [],
    this.qcTechnical = const [],
    this.projectStatusCounts = const [],
    this.countByType = const [],
    this.selectedRegionId,
    this.selectedRegionTitle,
  });

  String? get selectedRegionCode {
    if (selectedRegionId == null) return null;
    for (final area in areas) {
      if (area.id == selectedRegionId) return area.regionCode;
    }
    return null;
  }

  GlobalStatisticsBundle copyWith({
    GeneralStatisticsDto? general,
    ProjectExecutionSummaryDto? execution,
    List<AreaProjectDto>? areas,
    List<SectorProjectDto>? sectors,
    List<GlobalQcCategoryDto>? qcTechnical,
    List<StatisticsKeyValueDto>? projectStatusCounts,
    List<StatisticsKeyValueDto>? countByType,
    String? selectedRegionId,
    String? selectedRegionTitle,
    bool clearRegion = false,
  }) {
    return GlobalStatisticsBundle(
      general: general ?? this.general,
      execution: execution ?? this.execution,
      areas: areas ?? this.areas,
      sectors: sectors ?? this.sectors,
      qcTechnical: qcTechnical ?? this.qcTechnical,
      projectStatusCounts: projectStatusCounts ?? this.projectStatusCounts,
      countByType: countByType ?? this.countByType,
      selectedRegionId:
          clearRegion ? null : (selectedRegionId ?? this.selectedRegionId),
      selectedRegionTitle: clearRegion
          ? null
          : (selectedRegionTitle ?? this.selectedRegionTitle),
    );
  }
}

List<AreaProjectDto> parseAreaProjects(dynamic data) {
  if (data is! List) return const [];
  return data
      .whereType<Map<String, dynamic>>()
      .map(AreaProjectDto.fromJson)
      .toList();
}

List<SectorProjectDto> parseSectorProjects(dynamic data) {
  if (data is! List) return const [];
  return data
      .whereType<Map<String, dynamic>>()
      .map(SectorProjectDto.fromJson)
      .toList();
}

List<GlobalQcCategoryDto> parseGlobalQcCategories(dynamic data) {
  if (data is! List) return const [];
  return data
      .whereType<Map<String, dynamic>>()
      .map(GlobalQcCategoryDto.fromJson)
      .toList();
}
