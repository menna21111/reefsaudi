import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/financial_requirement.dart';
import '../../domain/usecases/get_financial_statements.dart';
import 'financial_requirements_event.dart';
import 'financial_requirements_state.dart';

class FinancialRequirementsBloc
    extends Bloc<FinancialRequirementsEvent, FinancialRequirementsState> {
  final GetFinancialStatementsUseCase getFinancialStatementsUseCase;
  static const int defaultPageSize = 10;

  FinancialRequirementsBloc({
    required this.getFinancialStatementsUseCase,
  }) : super(FinancialRequirementsInitial()) {
    on<LoadFinancialRequirements>(_onLoad);
    on<ChangeFinancialRequirementsPage>(_onChangePage);
    on<ChangeFinancialRequirementsPageSize>(_onChangePageSize);
    on<SearchFinancialRequirements>(_onSearch);
  }

  Future<void> _onLoad(
    LoadFinancialRequirements event,
    Emitter<FinancialRequirementsState> emit,
  ) async {
    await _fetchPage(
      emit,
      pageNumber: 1,
      pageSize: defaultPageSize,
      searchQuery: '',
      isInitial: true,
    );
  }

  Future<void> _onChangePage(
    ChangeFinancialRequirementsPage event,
    Emitter<FinancialRequirementsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FinancialRequirementsLoaded ||
        currentState.isPageLoading ||
        event.pageNumber == currentState.pageNumber) {
      return;
    }

    await _fetchPage(
      emit,
      pageNumber: event.pageNumber,
      pageSize: currentState.pageSize,
      searchQuery: currentState.searchQuery,
    );
  }

  Future<void> _onChangePageSize(
    ChangeFinancialRequirementsPageSize event,
    Emitter<FinancialRequirementsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FinancialRequirementsLoaded ||
        currentState.isPageLoading ||
        event.pageSize == currentState.pageSize) {
      return;
    }

    await _fetchPage(
      emit,
      pageNumber: 1,
      pageSize: event.pageSize,
      searchQuery: currentState.searchQuery,
    );
  }

  void _onSearch(
    SearchFinancialRequirements event,
    Emitter<FinancialRequirementsState> emit,
  ) {
    final currentState = state;
    if (currentState is! FinancialRequirementsLoaded) return;

    emit(currentState.copyWith(
      searchQuery: event.query,
      filteredItems: _filterItems(currentState.allItems, event.query),
    ));
  }

  Future<void> _fetchPage(
    Emitter<FinancialRequirementsState> emit, {
    required int pageNumber,
    required int pageSize,
    required String searchQuery,
    bool isInitial = false,
  }) async {
    if (isInitial) {
      emit(FinancialRequirementsLoading());
    } else if (state is FinancialRequirementsLoaded) {
      emit((state as FinancialRequirementsLoaded).copyWith(isPageLoading: true));
    }

    final result = await getFinancialStatementsUseCase(
      GetFinancialStatementsParams(
        pageNumber: pageNumber,
        pageSize: pageSize,
      ),
    );

    result.fold(
      (failure) {
        if (isInitial) {
          emit(FinancialRequirementsError(failure.errMessage));
        } else if (state is FinancialRequirementsLoaded) {
          emit((state as FinancialRequirementsLoaded).copyWith(
            isPageLoading: false,
          ));
        }
      },
      (data) => emit(FinancialRequirementsLoaded(
        allItems: data.items,
        filteredItems: _filterItems(data.items, searchQuery),
        searchQuery: searchQuery,
        pageNumber: data.pageNumber,
        pageSize: pageSize,
        totalPages: data.totalPages,
        totalCount: data.totalCount,
        hasPreviousPage: data.hasPreviousPage,
        hasNextPage: data.hasNextPage,
      )),
    );
  }

  List<FinancialRequirement> _filterItems(
    List<FinancialRequirement> items,
    String query,
  ) {
    if (query.isEmpty) return items;

    return items
        .where(
          (item) =>
              item.projectName.contains(query) ||
              item.sector.contains(query) ||
              item.extractNumber.contains(query),
        )
        .toList();
  }
}
