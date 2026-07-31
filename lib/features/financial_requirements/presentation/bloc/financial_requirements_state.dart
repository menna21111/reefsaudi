import 'package:equatable/equatable.dart';

import '../../domain/entities/financial_requirement.dart';

abstract class FinancialRequirementsState extends Equatable {
  const FinancialRequirementsState();

  @override
  List<Object?> get props => [];
}

class FinancialRequirementsInitial extends FinancialRequirementsState {}

class FinancialRequirementsLoading extends FinancialRequirementsState {}

class FinancialRequirementsLoaded extends FinancialRequirementsState {
  final List<FinancialRequirement> allItems;
  final List<FinancialRequirement> filteredItems;
  final String searchQuery;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final bool isPageLoading;
  final String? feedbackMessage;
  final bool feedbackIsError;

  const FinancialRequirementsLoaded({
    required this.allItems,
    required this.filteredItems,
    required this.searchQuery,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
    this.isPageLoading = false,
    this.feedbackMessage,
    this.feedbackIsError = false,
  });

  FinancialRequirementsLoaded copyWith({
    List<FinancialRequirement>? allItems,
    List<FinancialRequirement>? filteredItems,
    String? searchQuery,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    int? totalCount,
    bool? hasPreviousPage,
    bool? hasNextPage,
    bool? isPageLoading,
    String? feedbackMessage,
    bool? feedbackIsError,
    bool clearFeedback = false,
  }) {
    return FinancialRequirementsLoaded(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      feedbackMessage:
          clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
      feedbackIsError: feedbackIsError ?? this.feedbackIsError,
    );
  }

  @override
  List<Object?> get props => [
        allItems,
        filteredItems,
        searchQuery,
        pageNumber,
        pageSize,
        totalPages,
        totalCount,
        hasPreviousPage,
        hasNextPage,
        isPageLoading,
        feedbackMessage,
        feedbackIsError,
      ];
}

class FinancialRequirementsError extends FinancialRequirementsState {
  final String message;

  const FinancialRequirementsError(this.message);

  @override
  List<Object?> get props => [message];
}
