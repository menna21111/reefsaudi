import 'package:equatable/equatable.dart';

class Department extends Equatable {
  const Department({
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

class DepartmentListResult extends Equatable {
  const DepartmentListResult({
    required this.items,
    required this.totalCount,
  });

  final List<Department> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class DepartmentWriteRequest extends Equatable {
  const DepartmentWriteRequest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}
