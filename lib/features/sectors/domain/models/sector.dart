import 'package:equatable/equatable.dart';

class Sector extends Equatable {
  const Sector({
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

class SectorListResult extends Equatable {
  const SectorListResult({
    required this.items,
    required this.totalCount,
  });

  final List<Sector> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class SectorWriteRequest extends Equatable {
  const SectorWriteRequest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
