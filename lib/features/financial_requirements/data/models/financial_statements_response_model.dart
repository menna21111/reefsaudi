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

  PaginatedFinancialRequirements toEntity() {
    return PaginatedFinancialRequirements(
      items: items.map((item) => item.toEntity()).toList(),
      pageNumber: pageNumber ?? 1,
      totalPages: totalPages ?? 1,
      totalCount: totalCount ?? items.length,
      hasPreviousPage: hasPreviousPage ?? false,
      hasNextPage: hasNextPage ?? false,
    );
  }
}
