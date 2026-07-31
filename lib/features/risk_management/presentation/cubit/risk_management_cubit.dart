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

  String get _searchText {
    final current = state;
    return current is RiskManagementLoaded ? current.searchText : '';
  }

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

  Future<void> search(String query) async {
    final trimmed = query.trim();
    final current = state;
    if (current is RiskManagementLoaded) {
      emit(current.copyWith(searchText: trimmed, isRefreshing: true));
    } else {
      emit(const RiskManagementLoading());
    }

    final result = await repository.getProjectRisks(
      skip: 0,
      take: _pageSize,
      searchText: trimmed,
    );

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
          searchText: trimmed,
          projects: current is RiskManagementLoaded ? current.projects : const [],
          accounts: current is RiskManagementLoaded ? current.accounts : const [],
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final current = state;
    final searchText = _searchText;
    if (current is RiskManagementLoaded) {
      emit(current.copyWith(isRefreshing: true));
    }

    final result = await repository.getProjectRisks(
      skip: 0,
      take: _pageSize,
      searchText: searchText,
    );
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
          searchText: searchText,
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
      searchText: current.searchText,
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

  Future<List<ProjectDxItemDto>> fetchProjects() async {
    final result = await repository.getProjects();
    return result.fold((_) => <ProjectDxItemDto>[], (items) => items);
  }

  Future<List<AccountDxItemDto>> fetchAccounts() async {
    final result = await repository.getAccounts();
    return result.fold((_) => <AccountDxItemDto>[], (items) => items);
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

  Future<bool> updateRisk(ProjectRiskWriteRequest request) async {
    final current = state;
    if (current is! RiskManagementLoaded) return false;

    emit(current.copyWith(isSubmitting: true));

    final result = await repository.updateProjectRisk(request);
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

  Future<bool> deleteRisk(String riskId) async {
    final current = state;
    if (current is! RiskManagementLoaded) return false;

    emit(current.copyWith(isSubmitting: true));

    final result = await repository.deleteProjectRisk(riskId);
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
