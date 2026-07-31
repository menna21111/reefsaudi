import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepositoryImpl repository})
      : _repository = repository,
        super(const AuthState());

  final AuthRepositoryImpl _repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state.loginStatus == RequestStatus.loading) return;

    emit(state.copyWith(
      loginStatus: RequestStatus.loading,
      clearLoginError: true,
      clearProfile: true,
    ));

    final result = await _repository.login(
      email: email.trim(),
      password: password,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        loginStatus: RequestStatus.error,
        loginError: failure.errMessage,
      )),
      (profile) => emit(state.copyWith(
        loginStatus: RequestStatus.success,
        profile: profile,
      )),
    );
  }

  void resetLoginStatus() {
    if (state.loginStatus == RequestStatus.initial) return;
    emit(state.copyWith(
      loginStatus: RequestStatus.initial,
      clearLoginError: true,
    ));
  }
}
