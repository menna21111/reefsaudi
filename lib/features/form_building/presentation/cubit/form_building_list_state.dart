part of 'form_building_list_cubit.dart';

sealed class FormBuildingListState extends Equatable {
  const FormBuildingListState();

  @override
  List<Object?> get props => [];
}

final class FormBuildingListInitial extends FormBuildingListState {
  const FormBuildingListInitial();
}

final class FormBuildingListLoading extends FormBuildingListState {
  const FormBuildingListLoading();
}

final class FormBuildingListLoaded extends FormBuildingListState {
  const FormBuildingListLoaded({
    required this.items,
    required this.totalCount,
    this.isRefreshing = false,
  });

  final List<FormBuildingItem> items;
  final int totalCount;
  final bool isRefreshing;

  FormBuildingListLoaded copyWith({
    List<FormBuildingItem>? items,
    int? totalCount,
    bool? isRefreshing,
  }) {
    return FormBuildingListLoaded(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [items, totalCount, isRefreshing];
}

final class FormBuildingListError extends FormBuildingListState {
  const FormBuildingListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
