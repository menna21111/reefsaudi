import 'package:equatable/equatable.dart';

abstract class FinancialRequirementsEvent extends Equatable {
  const FinancialRequirementsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialRequirements extends FinancialRequirementsEvent {
  const LoadFinancialRequirements();
}

class ChangeFinancialRequirementsPage extends FinancialRequirementsEvent {
  final int pageNumber;

  const ChangeFinancialRequirementsPage(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class ChangeFinancialRequirementsPageSize extends FinancialRequirementsEvent {
  final int pageSize;

  const ChangeFinancialRequirementsPageSize(this.pageSize);

  @override
  List<Object?> get props => [pageSize];
}

class SearchFinancialRequirements extends FinancialRequirementsEvent {
  final String query;

  const SearchFinancialRequirements(this.query);

  @override
  List<Object?> get props => [query];
}
