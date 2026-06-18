import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/add_project_remote_data_source.dart';
import 'add_project_state.dart';

class AddProjectCubit extends Cubit<AddProjectState> {
  AddProjectCubit({required AddProjectRemoteDataSource dataSource})
      : _dataSource = dataSource,
        super(AddProjectInitial());

  final AddProjectRemoteDataSource _dataSource;

  Future<void> loadLookups() async {
    emit(AddProjectLoading());
    try {
      final contractors = await _dataSource.getSuppliers(type: 1);
      final consultants = await _dataSource.getSuppliers(type: 2);
      final accounts = await _dataSource.getAccounts();

      emit(
        AddProjectLoaded(
          contractors: contractors,
          consultants: consultants,
          accounts: accounts,
        ),
      );
    } catch (e) {
      emit(AddProjectError(e.toString()));
    }
  }

  Future<bool> submit() async {
    final current = state;
    if (current is! AddProjectLoaded) return false;

    emit(current.copyWith(isSubmitting: true));
    await Future<void>.delayed(const Duration(milliseconds: 400));
    emit(current.copyWith(isSubmitting: false));
    return true;
  }
}
