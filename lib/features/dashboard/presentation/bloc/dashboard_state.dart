import 'package:equatable/equatable.dart';

import '../../data/models/project_search_response_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardStatsLoading extends DashboardState {}

class DashboardStatsLoaded extends DashboardState {
  final DashboardStats stats;
  final String selectedStatus;
  final String? query;

  const DashboardStatsLoaded({
    required this.stats,
    this.selectedStatus = 'all',
    this.query,
  });

  @override
  List<Object?> get props => [stats, selectedStatus, query];

  DashboardStatsLoaded copyWith({
    DashboardStats? stats,
    String? selectedStatus,
    String? query,
  }) {
    return DashboardStatsLoaded(
      stats: stats ?? this.stats,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      query: query ?? this.query,
    );
  }
}

class DashboardStatsError extends DashboardState {
  final String message;

  const DashboardStatsError(this.message);

  @override
  List<Object?> get props => [message];
}
