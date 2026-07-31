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
    final received = items.length;
    final currentPage = pageNumber ?? 1;
    final entities = items.map((item) => item.toEntity()).toList();

    if (totalCount != null) {
      final pages =
          totalPages ??
          (totalCount == 0 ? 1 : ((totalCount! - 1) ~/ pageSize) + 1);
      return PaginatedFinancialRequirements(
        items: entities,
        pageNumber: currentPage,
        totalPages: pages < 1 ? 1 : pages,
        totalCount: totalCount!,
        hasPreviousPage: hasPreviousPage ?? currentPage > 1,
        hasNextPage: hasNextPage ?? currentPage < pages,
      );
    }

    // API didn't send totalCount — infer from whether this page is full.
    final hasMore = hasNextPage ?? received >= pageSize;
    final pages = totalPages ?? (hasMore ? currentPage + 1 : currentPage);

    return PaginatedFinancialRequirements(
      items: entities,
      pageNumber: currentPage,
      totalPages: pages < 1 ? 1 : pages,
      totalCount: received,
      hasPreviousPage: hasPreviousPage ?? currentPage > 1,
      hasNextPage: hasMore,
    );
  }
}
