import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/contractor.dart';
import '../../domain/repositories/contractors_repository.dart';

part 'contractors_state.dart';

class ContractorsCubit extends Cubit<ContractorsState> {
  ContractorsCubit({required this.repository})
      : super(const ContractorsInitial());

  final ContractorsRepository repository;
  static const int defaultPageSize = 10;

  Future<void> load() async {
    emit(const ContractorsLoading());
    await _fetchPage(page: 1, searchText: '');
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! ContractorsLoaded) {
      await load();
      return;
    }

    emit(current.copyWith(isRefreshing: true));
    await _fetchPage(
      page: current.currentPage,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> search(String query) async {
    final current = state;
    if (current is ContractorsLoaded) {
      emit(current.copyWith(searchText: query, isPageLoading: true));
    } else {
      emit(const ContractorsLoading());
    }

    await _fetchPage(page: 1, searchText: query);
  }

  Future<void> changePage(int page) async {
    final current = state;
    if (current is! ContractorsLoaded || current.isPageLoading) return;

    emit(current.copyWith(isPageLoading: true));
    await _fetchPage(
      page: page,
      searchText: current.searchText,
      keepPage: true,
    );
  }

  Future<void> changePageSize(int pageSize) async {
    final current = state;
    if (current is! ContractorsLoaded) return;

    emit(current.copyWith(pageSize: pageSize, isPageLoading: true));
    await _fetchPage(
      page: 1,
      searchText: current.searchText,
      pageSize: pageSize,
      keepPage: true,
    );
  }

  Future<bool> createContractor(ContractorWriteRequest request) async {
    final current = state;
    if (current is! ContractorsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.createContractor(request);

    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _fetchPage(
          page: current.currentPage,
          searchText: current.searchText,
          keepPage: true,
        );
        return true;
      },
    );
  }

  Future<bool> updateContractor({
    required String id,
    required ContractorWriteRequest request,
  }) async {
    final current = state;
    if (current is! ContractorsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.updateContractor(id: id, request: request);

    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _fetchPage(
          page: current.currentPage,
          searchText: current.searchText,
          keepPage: true,
        );
        return true;
      },
    );
  }

  Future<bool> deleteContractor(String id) async {
    final current = state;
    if (current is! ContractorsLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    final result = await repository.deleteContractor(id);

    return result.fold(
      (_) {
        emit(current.copyWith(isSubmitting: false));
        return false;
      },
      (_) async {
        emit(current.copyWith(isSubmitting: false));
        await _fetchPage(
          page: current.currentPage,
          searchText: current.searchText,
          keepPage: true,
        );
        return true;
      },
    );
  }

  Future<void> _fetchPage({
    required int page,
    required String searchText,
    int? pageSize,
    bool keepPage = false,
  }) async {
    final effectivePageSize = pageSize ??
        (state is ContractorsLoaded
            ? (state as ContractorsLoaded).pageSize
            : defaultPageSize);
    final skip = (page - 1) * effectivePageSize;

    final result = await repository.getContractors(
      skip: skip,
      take: effectivePageSize,
      searchText: searchText,
    );

    result.fold(
      (failure) {
        if (state is ContractorsLoaded && keepPage) {
          emit(
            (state as ContractorsLoaded).copyWith(
              isRefreshing: false,
              isPageLoading: false,
            ),
          );
        } else {
          emit(ContractorsError(failure.errMessage));
        }
      },
      (response) => emit(
        ContractorsLoaded(
          items: response.items,
          totalCount: response.totalCount,
          currentPage: page,
          pageSize: effectivePageSize,
          searchText: searchText,
        ),
      ),
    );
  }
}
