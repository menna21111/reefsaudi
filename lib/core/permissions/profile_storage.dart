import 'dart:convert';

import '../utils/cache_helper.dart';
import '../../features/auth/data/models/profile_model.dart';

class ProfileStorage {
  static const _profileKey = 'pmo_user_profile';

  Future<void> save(ProfileModel profile) async {
    await CacheHelper.saveData(
      key: _profileKey,
      value: jsonEncode(profile.toJson()),
    );
  }

  Future<ProfileModel?> load() async {
    final raw = CacheHelper.getData(key: _profileKey);
    if (raw is! String || raw.isEmpty) return null;
    try {
      return ProfileModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    await CacheHelper.removeData(key: _profileKey);
  }
}
