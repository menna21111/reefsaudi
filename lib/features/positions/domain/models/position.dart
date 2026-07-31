import 'package:equatable/equatable.dart';

class Position extends Equatable {
  const Position({
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

class PositionListResult extends Equatable {
  const PositionListResult({
    required this.items,
    required this.totalCount,
  });

  final List<Position> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class PositionWriteRequest extends Equatable {
  const PositionWriteRequest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
