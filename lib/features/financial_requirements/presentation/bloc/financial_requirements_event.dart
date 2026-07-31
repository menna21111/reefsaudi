import 'package:equatable/equatable.dart';

abstract class FinancialRequirementsEvent extends Equatable {
  const FinancialRequirementsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialRequirements extends FinancialRequirementsEvent {
  final int pageSize;

  const LoadFinancialRequirements({this.pageSize = 10});

  @override
  List<Object?> get props => [pageSize];
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

class ClearFinancialFeedback extends FinancialRequirementsEvent {
  const ClearFinancialFeedback();
}

class DeleteFinancialRequirement extends FinancialRequirementsEvent {
  final String id;

  const DeleteFinancialRequirement(this.id);

  @override
  List<Object?> get props => [id];
}
