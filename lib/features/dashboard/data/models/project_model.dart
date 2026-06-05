import '../../domain/entities/project.dart';

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
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      budget: (json['budget'] as num).toDouble(),
      status: json['status'] as String,
      progress: (json['progress'] as num).toDouble(),
      entityName: json['entityName'] as String,
      daysLeft: json['daysLeft'] as int?,
    );
  }

  /// Maps PMO `POST /project/search` items to dashboard [Project].
  factory ProjectModel.fromPmoJson(Map<String, dynamic> json) {
    final brand = json['brandTitle'] as String? ?? '';
    final product = json['product'] as String? ?? '';
    final sizeML = json['sizeML'] as String? ?? '';
    final segments = [brand, product, sizeML].where((s) => s.isNotEmpty);
    final compositeTitle = segments.join(' - ');

    final currentStep = json['currentStep'] as Map<String, dynamic>?;
    final stepStatus = currentStep?['status'] as Map<String, dynamic>?;
    final stepTitle = stepStatus?['title'] as String?;
    final projectStatusCode = json['status'] as int?;

    return ProjectModel(
      id: json['id'] as String,
      title: compositeTitle.isNotEmpty
          ? compositeTitle
          : (json['title'] as String? ?? ''),
      description: json['activityTitle'] as String? ??
          json['title'] as String? ??
          '',
      budget: (json['quantity'] as num?)?.toDouble() ?? 0,
      status: _mapPmoUiStatus(stepTitle, projectStatusCode),
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      entityName: stepStatus?['titleAr'] as String? ?? '',
      daysLeft: json['dayesLeft'] as int?,
    );
  }

  static String _mapPmoUiStatus(String? stepTitle, int? projectStatusCode) {
    if (stepTitle == 'Finished' || projectStatusCode == 5) {
      return 'finished';
    }
    if (stepTitle == 'Critical' || stepTitle == 'Delayed') {
      return 'stalled';
    }
    return 'in_progress';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'budget': budget,
      'status': status,
      'progress': progress,
      'entityName': entityName,
      'daysLeft': daysLeft,
    };
  }
}
