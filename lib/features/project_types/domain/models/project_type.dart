import 'package:equatable/equatable.dart';

class ProjectType extends Equatable {
  const ProjectType({
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

class ProjectTypeListResult extends Equatable {
  const ProjectTypeListResult({
    required this.items,
    required this.totalCount,
  });

  final List<ProjectType> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class ProjectTypeWriteRequest extends Equatable {
  const ProjectTypeWriteRequest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
