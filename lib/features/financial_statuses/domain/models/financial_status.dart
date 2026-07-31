import 'package:equatable/equatable.dart';

class FinancialStatusItem extends Equatable {
  const FinancialStatusItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isFinal,
  });

  final String id;
  final String title;
  final String description;
  final bool isFinal;

  @override
  List<Object?> get props => [id, title, description, isFinal];
}

class FinancialStatusListResult extends Equatable {
  const FinancialStatusListResult({
    required this.items,
    required this.totalCount,
  });

  final List<FinancialStatusItem> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class FinancialStatusWriteRequest extends Equatable {
  const FinancialStatusWriteRequest({
    required this.title,
    required this.description,
    required this.isFinal,
  });

  final String title;
  final String description;
  final bool isFinal;

  @override
  List<Object?> get props => [title, description, isFinal];
}
