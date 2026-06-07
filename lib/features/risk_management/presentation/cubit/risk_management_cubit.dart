import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../project/data/models/project_api_models.dart';
import '../../data/models/project_risk_models.dart';
import '../../domain/repositories/risk_repository.dart';

part 'risk_management_state.dart';

class RiskManagementCubit extends Cubit<RiskManagementState> {
  RiskManagementCubit({required this.repository})
      : super(const RiskManagementInitial());

  final RiskRepository repository;
  static const int _pageSize = 10;

  Future<void> load() async {
    emit(const RiskManagementLoading());

    final result = await repository.getProjectRisks(skip: 0, take: _pageSize);
    result.fold(
      (failure) => emit(RiskManagementError(failure.errMessage)),
      (response) => emit(
        RiskManagementLoaded(
          risks: response.data,
          totalCount: response.totalCount,
          skip: 0,
          take: _pageSize,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final current = state;
    if (current is RiskManagementLoaded) {
      emit(current.copyWith(isRefreshing: true));
    }

    final result = await repository.getProjectRisks(skip: 0, take: _pageSize);
    result.fold(
      (failure) {
        if (current is RiskManagementLoaded) {
          emit(current.copyWith(isRefreshing: false));
        } else {
          emit(RiskManagementError(failure.errMessage));
        }
      },
      (response) => emit(
        RiskManagementLoaded(
          risks: response.data,
          totalCount: response.totalCount,
          skip: 0,
          take: _pageSize,
          projects: current is RiskManagementLoaded ? current.projects : const [],
          accounts: current is RiskManagementLoaded ? current.accounts : const [],
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! RiskManagementLoaded ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextSkip = current.risks.length;
    final result = await repository.getProjectRisks(
      skip: nextSkip,
      take: _pageSize,
    );

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (response) => emit(
        current.copyWith(
          risks: [...current.risks, ...response.data],
          totalCount: response.totalCount,
          skip: nextSkip,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> loadFormData() async {
    final current = state;
    if (current is! RiskManagementLoaded) return;
    if (current.projects.isNotEmpty && current.accounts.isNotEmpty) return;

    emit(current.copyWith(isFormDataLoading: true));

    final projectsResult = await repository.getProjects();
    final accountsResult = await repository.getAccounts();

    projectsResult.fold(
      (_) => emit(current.copyWith(isFormDataLoading: false)),
      (projects) {
        accountsResult.fold(
          (_) => emit(current.copyWith(isFormDataLoading: false)),
          (accounts) => emit(
            current.copyWith(
              projects: projects,
              accounts: accounts,
              isFormDataLoading: false,
            ),
          ),
        );
      },
    );
  }

  Future<bool> createRisk(CreateProjectRiskRequest request) async {
    final current = state;
    if (current is! RiskManagementLoaded) return false;

    emit(current.copyWith(isSubmitting: true));

    final result = await repository.createProjectRisk(request);
    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await refresh();
        return true;
      },
    );
  }
}
