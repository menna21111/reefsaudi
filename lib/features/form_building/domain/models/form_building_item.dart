import 'package:equatable/equatable.dart';

class FormBuildingItem extends Equatable {
  const FormBuildingItem({
    required this.id,
    required this.title,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;

  @override
  List<Object?> get props => [id, title, subtitle];
}

class FormBuildingListResult extends Equatable {
  const FormBuildingListResult({required this.items, required this.totalCount});

  final List<FormBuildingItem> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}
