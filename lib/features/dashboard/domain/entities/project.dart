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
  final String brandTitle;
  final String product;
  final String sizeML;

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
    this.brandTitle = '',
    this.product = '',
    this.sizeML = '',
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
        brandTitle,
        product,
        sizeML,
      ];
}
