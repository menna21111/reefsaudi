import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/account_user_type.dart';
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
      final contractors =
          await _dataSource.getAccountsByUserType(AccountUserType.contractor);
      final consultants =
          await _dataSource.getAccountsByUserType(AccountUserType.consultant);
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
