import '../../domain/entities/paginated_financial_requirements.dart';
import 'financial_statement_model.dart';

class FinancialStatementsResponseModel {
  final List<FinancialStatementModel> items;
  final int? pageNumber;
  final int? totalPages;
  final int? totalCount;
  final bool? hasPreviousPage;
  final bool? hasNextPage;

  const FinancialStatementsResponseModel({
    required this.items,
    this.pageNumber,
    this.totalPages,
    this.totalCount,
    this.hasPreviousPage,
    this.hasNextPage,
  });

  factory FinancialStatementsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return FinancialStatementsResponseModel(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(FinancialStatementModel.fromJson)
          .toList(),
      pageNumber: json['pageNumber'] as int?,
      totalPages: json['totalPages'] as int?,
      totalCount: json['totalCount'] as int?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      hasNextPage: json['hasNextPage'] as bool?,
    );
  }

  PaginatedFinancialRequirements toEntity({required int pageSize}) {
    final count = totalCount ?? items.length;
    final currentPage = pageNumber ?? 1;
    final received = items.length;

    // When the API returns the full dataset in one response, keep all rows visible.
    final allLoadedInOneResponse = received >= count ||
        (hasNextPage == false && received > pageSize);

    final pages = totalPages ??
        (allLoadedInOneResponse ? 1 : (count / pageSize).ceil().clamp(1, 999999));

    return PaginatedFinancialRequirements(
      items: items.map((item) => item.toEntity()).toList(),
      pageNumber: currentPage,
      totalPages: pages,
      totalCount: count,
      hasPreviousPage: allLoadedInOneResponse
          ? false
          : (hasPreviousPage ?? currentPage > 1),
      hasNextPage: allLoadedInOneResponse
          ? false
          : (hasNextPage ?? currentPage < pages),
    );
  }
}
