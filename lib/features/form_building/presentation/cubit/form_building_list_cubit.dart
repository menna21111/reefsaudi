import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/form_building_item.dart';
import '../../domain/models/form_building_module.dart';
import '../../domain/repositories/form_building_repository.dart';

part 'form_building_list_state.dart';

class FormBuildingListCubit extends Cubit<FormBuildingListState> {
  FormBuildingListCubit({required this.repository, required this.module})
    : super(const FormBuildingListInitial());

  final FormBuildingRepository repository;
  final FormBuildingModule module;

  Future<void> load() async {
    emit(const FormBuildingListLoading());

    final result = await repository.getItems(module: module);
    result.fold(
      (failure) => emit(FormBuildingListError(failure.errMessage)),
      (response) => emit(
        FormBuildingListLoaded(
          items: response.items,
          totalCount: response.totalCount,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final current = state;
    if (current is FormBuildingListLoaded) {
      emit(current.copyWith(isRefreshing: true));
    }

    final result = await repository.getItems(module: module);
    result.fold(
      (failure) {
        if (current is FormBuildingListLoaded) {
          emit(current.copyWith(isRefreshing: false));
        } else {
          emit(FormBuildingListError(failure.errMessage));
        }
      },
      (response) => emit(
        FormBuildingListLoaded(
          items: response.items,
          totalCount: response.totalCount,
        ),
      ),
    );
  }
}
