import 'package:equatable/equatable.dart';
import '../../domain/entities/project.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Project> allProjects;
  final List<Project> filteredProjects;
  final String selectedStatus; // 'all', 'in_progress', 'stalled', 'finished'

  const DashboardLoaded({
    required this.allProjects,
    required this.filteredProjects,
    required this.selectedStatus,
  });

  @override
  List<Object?> get props => [allProjects, filteredProjects, selectedStatus];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
