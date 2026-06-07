import '../../domain/entities/project.dart';
import 'pmo_project_dto.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.budget,
    required super.status,
    required super.progress,
    required super.entityName,
    super.daysLeft,
    super.statusColor,
  });

  factory ProjectModel.fromDto(PmoProjectDto dto) {
    final segments = [dto.brandTitle, dto.product, dto.sizeML]
        .where((s) => s.trim().isNotEmpty);
    final compositeTitle = segments.join(' - ');

    return ProjectModel(
      id: dto.id,
      title: compositeTitle.isNotEmpty ? compositeTitle : dto.title,
      description: dto.activityTitle.trim().isNotEmpty
          ? dto.activityTitle
          : dto.title,
      budget: dto.quantity.toDouble(),
      status: _mapUiStatus(dto.currentStep?.status.title, dto.status),
      progress: dto.progress.toDouble(),
      entityName: dto.currentStep?.status.titleAr ?? '',
      daysLeft: dto.dayesLeft,
      statusColor: dto.currentStep?.status.color,
    );
  }

  static String _mapUiStatus(String? stepTitle, int projectStatusCode) {
    if (stepTitle == 'Finished' || projectStatusCode == 5) {
      return 'finished';
    }
    if (stepTitle == 'Critical' || stepTitle == 'Delayed') {
      return 'stalled';
    }
    return 'in_progress';
  }
}
