import 'dart:convert';

class ProjectDataDto {
  final String projectId;
  final String stepTitle;
  final String stepStatus;
  final String statusColor;
  final String projectTitle;
  final double contractualBudget;
  final String startDate;
  final String endDate;
  final int projectDuration;
  final int finesidDuration;
  final int remainDuration;
  final String brandTitle;
  final String productTitle;
  final String sizeMlTitle;
  final String consultantTitle;
  final String contractorTitle;

  const ProjectDataDto({
    required this.projectId,
    required this.stepTitle,
    required this.stepStatus,
    required this.statusColor,
    required this.projectTitle,
    required this.contractualBudget,
    required this.startDate,
    required this.endDate,
    required this.projectDuration,
    required this.finesidDuration,
    required this.remainDuration,
    required this.brandTitle,
    required this.productTitle,
    required this.sizeMlTitle,
    required this.consultantTitle,
    required this.contractorTitle,
  });

  factory ProjectDataDto.fromJson(Map<String, dynamic> json) {
    return ProjectDataDto(
      projectId: json['projectId']?.toString() ?? '',
      stepTitle: json['stepTitle']?.toString() ?? '',
      stepStatus: json['stepStatus']?.toString() ?? '',
      statusColor: json['statusColor']?.toString() ?? '',
      projectTitle: json['projectTitle']?.toString() ?? '',
      contractualBudget: _toDouble(json['contractualBudget']),
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      projectDuration: _toInt(json['projectDuration']),
      finesidDuration: _toInt(json['finesidDuration']),
      remainDuration: _toInt(json['remainDuration']),
      brandTitle: json['brandTitle']?.toString() ?? '',
      productTitle: json['productTitle']?.toString() ?? '',
      sizeMlTitle: json['sizeMlTitle']?.toString() ?? '',
      consultantTitle: json['consultantTitle']?.toString() ?? '',
      contractorTitle: json['contractorTitle']?.toString() ?? '',
    );
  }

  String get categoryLabel =>
      [brandTitle, productTitle, sizeMlTitle].where((v) => v.isNotEmpty).join(' - ');
}

class ProjectExecutiveSummaryDto {
  final String? executiveSummary;
  final double actual;
  final double planned;
  final double diffraction;
  final String achievementTitle;
  final String projectId;
  final String stepTitle;
  final bool isFinal;
  final String assignedDate;
  final double completionPercent;
  final int statusCode;
  final String stepStatus;
  final String statusColor;

  const ProjectExecutiveSummaryDto({
    this.executiveSummary,
    required this.actual,
    required this.planned,
    required this.diffraction,
    required this.achievementTitle,
    required this.projectId,
    required this.stepTitle,
    required this.isFinal,
    required this.assignedDate,
    required this.completionPercent,
    required this.statusCode,
    required this.stepStatus,
    required this.statusColor,
  });

  factory ProjectExecutiveSummaryDto.fromJson(Map<String, dynamic> json) {
    return ProjectExecutiveSummaryDto(
      executiveSummary: json['executiveSummary']?.toString(),
      actual: _toDouble(json['actual']),
      planned: _toDouble(json['planned']),
      diffraction: _toDouble(json['diffraction']),
      achievementTitle: json['achievementTitle']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      stepTitle: json['stepTitle']?.toString() ?? '',
      isFinal: json['isFinal'] == true,
      assignedDate: json['assignedDate']?.toString() ?? '',
      completionPercent: _toDouble(json['completionPercent']),
      statusCode: _toInt(json['statusCode']),
      stepStatus: json['stepStatus']?.toString() ?? '',
      statusColor: json['statusColor']?.toString() ?? '',
    );
  }

  factory ProjectExecutiveSummaryDto.fromProjectData(ProjectDataDto data) {
    return ProjectExecutiveSummaryDto(
      executiveSummary: null,
      actual: 0,
      planned: 0,
      diffraction: 0,
      achievementTitle: '',
      projectId: data.projectId,
      stepTitle: data.stepTitle,
      isFinal: false,
      assignedDate: '',
      completionPercent: 0,
      statusCode: 0,
      stepStatus: data.stepStatus,
      statusColor: data.statusColor,
    );
  }
}

class ProjectStageDto {
  final String title;
  final num actual;
  final num planned;

  const ProjectStageDto({
    required this.title,
    required this.actual,
    required this.planned,
  });

  factory ProjectStageDto.fromJson(Map<String, dynamic> json) {
    return ProjectStageDto(
      title: json['title']?.toString() ?? '',
      actual: json['actual'] ?? 0,
      planned: json['planned'] ?? 0,
    );
  }

  double get progressRatio {
    if (planned == 0) return actual / 100;
    return (actual / planned).clamp(0, 1).toDouble();
  }
}

class ProjectStatementsDto {
  final double budget;
  final double totalContracts;
  final int financialStatementsCount;
  final double remainingBudget;
  final double disbursedAmount;
  final double pendingAmount;
  final double maxActual;

  const ProjectStatementsDto({
    required this.budget,
    required this.totalContracts,
    required this.financialStatementsCount,
    required this.remainingBudget,
    required this.disbursedAmount,
    required this.pendingAmount,
    required this.maxActual,
  });

  factory ProjectStatementsDto.fromJson(Map<String, dynamic> json) {
    return ProjectStatementsDto(
      budget: _toDouble(json['budget']),
      totalContracts: _toDouble(json['totalContracts']),
      financialStatementsCount: _toInt(json['financialStatementsCount']),
      remainingBudget: _toDouble(json['remainingBudget']),
      disbursedAmount: _toDouble(json['disbursedAmount']),
      pendingAmount: _toDouble(json['pendingAmount']),
      maxActual: _toDouble(json['maxActual']),
    );
  }

  factory ProjectStatementsDto.empty() {
    return const ProjectStatementsDto(
      budget: 0,
      totalContracts: 0,
      financialStatementsCount: 0,
      remainingBudget: 0,
      disbursedAmount: 0,
      pendingAmount: 0,
      maxActual: 0,
    );
  }
}

class ProjectAchievementPointDto {
  final String title;
  final num actual;
  final num planned;

  const ProjectAchievementPointDto({
    required this.title,
    required this.actual,
    required this.planned,
  });

  factory ProjectAchievementPointDto.fromJson(Map<String, dynamic> json) {
    return ProjectAchievementPointDto(
      title: json['title']?.toString() ?? '',
      actual: json['actual'] ?? 0,
      planned: json['planned'] ?? 0,
    );
  }
}

class RiskMatrixItemDto {
  final String id;
  final String title;
  final String contingencyPlan;
  final String responsePlan;
  final int probability;
  final int impact;
  final int priority;
  final int score;

  const RiskMatrixItemDto({
    required this.id,
    required this.title,
    required this.contingencyPlan,
    required this.responsePlan,
    required this.probability,
    required this.impact,
    required this.priority,
    required this.score,
  });

  factory RiskMatrixItemDto.fromJson(Map<String, dynamic> json) {
    return RiskMatrixItemDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      contingencyPlan: json['contingencyPlan']?.toString() ?? '',
      responsePlan: json['responsePlan']?.toString() ?? '',
      probability: _toInt(json['probability']),
      impact: _toInt(json['impact']),
      priority: _toInt(json['priority']),
      score: _toInt(json['score']),
    );
  }

  int get matrixIndex {
    final row = (5 - probability).clamp(1, 5);
    final col = impact.clamp(1, 5);
    return ((row - 1) * 5) + (col - 1);
  }
}

class QcCategoryDto {
  final String category;
  final int statementsCount;

  const QcCategoryDto({
    required this.category,
    required this.statementsCount,
  });

  factory QcCategoryDto.fromJson(Map<String, dynamic> json) {
    return QcCategoryDto(
      category: json['category']?.toString() ?? '',
      statementsCount: _toInt(json['statementsCount']),
    );
  }
}

class AchievementManualItemDto {
  final String id;
  final double planned;
  final double actual;
  final String monthYear;
  final String projectId;

  const AchievementManualItemDto({
    required this.id,
    required this.planned,
    required this.actual,
    required this.monthYear,
    required this.projectId,
  });

  factory AchievementManualItemDto.fromJson(Map<String, dynamic> json) {
    return AchievementManualItemDto(
      id: json['id']?.toString() ?? '',
      planned: _toDouble(json['planned']),
      actual: _toDouble(json['actual']),
      monthYear: json['monthYear']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
    );
  }
}

class AchievementManualListResponse {
  final List<AchievementManualItemDto> data;
  final int totalCount;

  const AchievementManualListResponse({
    required this.data,
    required this.totalCount,
  });

  factory AchievementManualListResponse.fromJson(Map<String, dynamic> json) {
    return AchievementManualListResponse(
      data: parseAchievementManualItems(json['data']),
      totalCount: _toInt(json['totalCount']),
    );
  }

  List<AchievementManualItemDto> get chronological =>
      List<AchievementManualItemDto>.from(data.reversed);
}

class ProjectStepItemDto {
  final String id;
  final String projectId;
  final String projectTitle;
  final String pStepId;
  final String pStepTitle;
  final String assignedDate;
  final bool isCompleted;

  const ProjectStepItemDto({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.pStepId,
    required this.pStepTitle,
    required this.assignedDate,
    required this.isCompleted,
  });

  factory ProjectStepItemDto.fromJson(Map<String, dynamic> json) {
    return ProjectStepItemDto(
      id: json['id']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      projectTitle: json['projectTitle']?.toString() ?? '',
      pStepId: json['pStepId']?.toString() ?? '',
      pStepTitle: json['pStepTitle']?.toString() ?? '',
      assignedDate: json['assignedDate']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true,
    );
  }
}

class PaginatedProjectStepsDto {
  final List<ProjectStepItemDto> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;

  const PaginatedProjectStepsDto({
    required this.items,
    required this.pageNumber,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
  });

  factory PaginatedProjectStepsDto.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProjectStepItemDto.fromJson)
        .toList();

    return PaginatedProjectStepsDto(
      items: items,
      pageNumber: _toInt(json['pageNumber'], fallback: 1),
      totalPages: _toInt(json['totalPages'], fallback: 1),
      totalCount: _toInt(json['totalCount']),
      hasNextPage: json['hasNextPage'] == true,
    );
  }
}

class ProjectDxItemDto {
  final String id;
  final String title;
  final String brandId;
  final String brand;
  final String product;
  final String sizeML;
  final String productionLine;

  const ProjectDxItemDto({
    required this.id,
    required this.title,
    required this.brandId,
    required this.brand,
    required this.product,
    required this.sizeML,
    required this.productionLine,
  });

  factory ProjectDxItemDto.fromJson(Map<String, dynamic> json) {
    return ProjectDxItemDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      brandId: json['brandId']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      product: json['product']?.toString() ?? '',
      sizeML: json['sizeML']?.toString() ?? '',
      productionLine: json['productionLine']?.toString() ?? '',
    );
  }
}

class DxListResponse<T> {
  final List<T> data;
  final int totalCount;

  const DxListResponse({required this.data, required this.totalCount});
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}

List<T> _parseList<T>(
  dynamic raw,
  T Function(Map<String, dynamic> json) mapper,
) {
  if (raw is List) {
    return raw.whereType<Map<String, dynamic>>().map(mapper).toList();
  }
  return [];
}

List<ProjectStageDto> parseProjectStages(dynamic raw) =>
    _parseList(raw, ProjectStageDto.fromJson);

List<ProjectAchievementPointDto> parseProjectAchievement(dynamic raw) =>
    _parseList(raw, ProjectAchievementPointDto.fromJson);

List<RiskMatrixItemDto> parseRiskMatrix(dynamic raw) =>
    _parseList(raw, RiskMatrixItemDto.fromJson);

List<QcCategoryDto> parseQcCategories(dynamic raw) =>
    _parseList(raw, QcCategoryDto.fromJson);

List<AchievementManualItemDto> parseAchievementManualItems(dynamic raw) =>
    _parseList(raw, AchievementManualItemDto.fromJson);

List<ProjectDxItemDto> parseProjectDxItems(dynamic raw) =>
    _parseList(raw, ProjectDxItemDto.fromJson);

List<ProjectStepItemDto> parseProjectStepItems(dynamic raw) =>
    _parseList(raw, ProjectStepItemDto.fromJson);

class ProjectImageDto {
  const ProjectImageDto({
    required this.name,
    required this.size,
    required this.imageUrl,
  });

  final String name;
  final int size;
  final String imageUrl;

  factory ProjectImageDto.fromJson(Map<String, dynamic> json) {
    return ProjectImageDto(
      name: json['name']?.toString() ?? '',
      size: _toInt(json['size']),
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }
}

List<ProjectImageDto> parseProjectImages(dynamic raw) {
  if (raw is String && raw.trim().isNotEmpty) {
    try {
      return parseProjectImages(jsonDecode(raw));
    } catch (_) {
      return const [];
    }
  }

  if (raw is Map) {
    final map = Map<String, dynamic>.from(raw);
    for (final key in const ['data', 'Data', 'items', 'Items', 'result', 'Result']) {
      final value = map[key];
      if (value != null) {
        final parsed = parseProjectImages(value);
        if (parsed.isNotEmpty) return parsed;
      }
    }
  }

  if (raw is List) {
    return raw
        .whereType<Map>()
        .map((item) => ProjectImageDto.fromJson(Map<String, dynamic>.from(item)))
        .where((image) => image.imageUrl.trim().isNotEmpty)
        .toList();
  }
  return const [];
}

String formatApiDate(String raw) {
  if (raw.isEmpty) return raw;
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw.split('T').first;
  return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
}
