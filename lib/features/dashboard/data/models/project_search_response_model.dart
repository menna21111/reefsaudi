import '../../domain/entities/project.dart';
import 'pmo_project_dto.dart';
import 'project_model.dart';

class DashboardStats {
  final int total;
  final int underExecution;
  final int delayed;
  final double totalBudget;

  const DashboardStats({
    required this.total,
    required this.underExecution,
    required this.delayed,
    required this.totalBudget,
  });

  const DashboardStats.empty()
      : total = 0,
        underExecution = 0,
        delayed = 0,
        totalBudget = 0;

  DashboardStats copyWith({
    int? total,
    int? underExecution,
    int? delayed,
    double? totalBudget,
  }) {
    return DashboardStats(
      total: total ?? this.total,
      underExecution: underExecution ?? this.underExecution,
      delayed: delayed ?? this.delayed,
      totalBudget: totalBudget ?? this.totalBudget,
    );
  }

  factory DashboardStats.fromDto(
    ProjectSearchResponseDto dto, {
    double totalBudget = 0,
  }) {
    final statusGroup = dto.aggregations
        .where((group) => group.title.toLowerCase() == 'status')
        .firstOrNull;

    int countByIdentifier(String id) {
      if (statusGroup == null) return 0;
      for (final value in statusGroup.values) {
        if (value.identifier == id) return value.count;
      }
      return 0;
    }

    final started = countByIdentifier('0');
    final awarded = countByIdentifier('1');
    final review = countByIdentifier('3');
    final tender = countByIdentifier('6');

    return DashboardStats(
      total: dto.total,
      underExecution: started,
      delayed: awarded + review + tender,
      totalBudget: totalBudget,
    );
  }
}

class ProjectSearchResult {
  final List<Project> projects;
  final int total;
  final DashboardStats? stats;

  const ProjectSearchResult({
    required this.projects,
    required this.total,
    this.stats,
  });

  factory ProjectSearchResult.fromDto(
    ProjectSearchResponseDto dto, {
    bool withStats = false,
    double totalBudget = 0,
  }) {
    final projects = dto.data.map(ProjectModel.fromDto).toList();

    return ProjectSearchResult(
      projects: projects,
      total: dto.total,
      stats: withStats
          ? DashboardStats.fromDto(dto, totalBudget: totalBudget)
          : null,
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
