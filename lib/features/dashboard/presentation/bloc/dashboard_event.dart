import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardProjects extends DashboardEvent {}

class FilterProjects extends DashboardEvent {
  final String status;

  const FilterProjects(this.status);

  @override
  List<Object?> get props => [status];
}
