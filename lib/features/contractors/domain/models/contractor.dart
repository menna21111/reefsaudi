import 'package:equatable/equatable.dart';

class Contractor extends Equatable {
  const Contractor({
    required this.id,
    required this.title,
    required this.description,
    required this.currency,
    required this.type,
  });

  final String id;
  final String title;
  final String description;
  final String currency;
  final int type;

  bool get isConsultant => type == 0;
  bool get isContractor => type == 1;

  @override
  List<Object?> get props => [id, title, description, currency, type];
}

class ContractorListResult extends Equatable {
  const ContractorListResult({
    required this.items,
    required this.totalCount,
  });

  final List<Contractor> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class ContractorWriteRequest extends Equatable {
  const ContractorWriteRequest({
    required this.title,
    required this.description,
    required this.currency,
    required this.type,
  });

  final String title;
  final String description;
  final String currency;
  final int type;

  @override
  List<Object?> get props => [title, description, currency, type];
}
