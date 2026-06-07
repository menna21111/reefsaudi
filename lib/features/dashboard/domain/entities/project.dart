import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final double budget;
  final String status; // 'stalled', 'finished', 'in_progress'
  final double progress; // percentage (e.g. 42.0)
  final String entityName; // e.g. 'منصة اعتماد' or 'شركة الخريف'
  final int? daysLeft;
  final String? statusColor;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.status,
    required this.progress,
    required this.entityName,
    this.daysLeft,
    this.statusColor,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        budget,
        status,
        progress,
        entityName,
        daysLeft,
        statusColor,
      ];
}
