import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardStats extends DashboardEvent {
  const LoadDashboardStats();
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

class FilterProjects extends DashboardEvent {
  final String status;

  const FilterProjects(this.status);

  @override
  List<Object> get props => [status];
}

class SearchProjects extends DashboardEvent {
  final String? query;

  const SearchProjects(this.query);

  @override
  List<Object?> get props => [query];
}
