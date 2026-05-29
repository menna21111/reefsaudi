import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../domain/usecases/get_projects.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetProjectsUseCase getProjectsUseCase;

  DashboardBloc({required this.getProjectsUseCase}) : super(DashboardInitial()) {
    on<LoadDashboardProjects>(_onLoadProjects);
    on<FilterProjects>(_onFilterProjects);
  }

  Future<void> _onLoadProjects(
    LoadDashboardProjects event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await getProjectsUseCase(const NoParams());
    result.fold(
      (failure) => emit(DashboardError(failure.errMessage)),
      (projects) => emit(DashboardLoaded(
        allProjects: projects,
        filteredProjects: projects,
        selectedStatus: 'all',
      )),
    );
  }

  void _onFilterProjects(
    FilterProjects event,
    Emitter<DashboardState> emit,
  ) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      if (event.status == 'all') {
        emit(DashboardLoaded(
          allProjects: currentState.allProjects,
          filteredProjects: currentState.allProjects,
          selectedStatus: 'all',
        ));
      } else {
        final filtered = currentState.allProjects
            .where((project) => project.status == event.status)
            .toList();
        emit(DashboardLoaded(
          allProjects: currentState.allProjects,
          filteredProjects: filtered,
          selectedStatus: event.status,
        ));
      }
    }
  }
}
