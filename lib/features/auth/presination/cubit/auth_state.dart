part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({
    this.loginStatus = RequestStatus.initial,
    this.loginError = '',
    this.profile,
  });

  final RequestStatus loginStatus;
  final String loginError;
  final ProfileModel? profile;

  bool get isLoginLoading => loginStatus == RequestStatus.loading;

  AuthState copyWith({
    RequestStatus? loginStatus,
    String? loginError,
    bool clearLoginError = false,
    ProfileModel? profile,
    bool clearProfile = false,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      loginError: clearLoginError ? '' : loginError ?? this.loginError,
      profile: clearProfile ? null : profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [loginStatus, loginError, profile];
}
