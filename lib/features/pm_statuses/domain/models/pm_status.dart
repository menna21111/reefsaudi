import 'package:equatable/equatable.dart';

class PmStatus extends Equatable {
  const PmStatus({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  @override
  List<Object?> get props => [id, title, description];
}

class PmStatusListResult extends Equatable {
  const PmStatusListResult({
    required this.items,
    required this.totalCount,
  });

  final List<PmStatus> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class PmStatusWriteRequest extends Equatable {
  const PmStatusWriteRequest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
