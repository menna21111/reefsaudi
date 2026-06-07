import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/models/profile_model.dart';
import 'app_permissions.dart';
import 'profile_storage.dart';

class PermissionCubit extends Cubit<ProfileModel?> {
  final ProfileStorage _profileStorage;

  PermissionCubit(this._profileStorage) : super(null);

  Future<void> loadCached() async {
    emit(await _profileStorage.load());
  }

  Future<void> setProfile(ProfileModel profile) async {
    await _profileStorage.save(profile);
    emit(profile);
  }

  Future<void> clear() async {
    await _profileStorage.clear();
    emit(null);
  }

  bool has(String permission) => state?.hasPermission(permission) ?? false;

  bool hasAny(Iterable<String> permissions) => permissions.any(has);

  bool get canViewProjects => has(AppPermissions.projectView);

  bool get canEditProjects => has(AppPermissions.projectEdit);

  bool get canViewDashboard => has(AppPermissions.dashboardView);

  bool get canViewTasks => has(AppPermissions.taskView);

  bool get canViewFinancial =>
      has(AppPermissions.financialView) ||
      has(AppPermissions.quotationView);
}
