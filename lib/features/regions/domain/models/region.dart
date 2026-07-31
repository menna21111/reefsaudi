import 'package:equatable/equatable.dart';

class Region extends Equatable {
  const Region({
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

class RegionListResult extends Equatable {
  const RegionListResult({
    required this.items,
    required this.totalCount,
  });

  final List<Region> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class RegionWriteRequest extends Equatable {
  const RegionWriteRequest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
