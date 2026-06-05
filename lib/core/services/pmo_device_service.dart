import 'dart:math';

import '../utils/cache_helper.dart';

/// Supplies PMO login fields: persistent [deviceId] and [firebaseToken].
class PmoDeviceService {
  static const _deviceIdKey = 'pmo_device_id';
  static const _firebaseTokenKey = 'pmo_firebase_token';

  Future<String> getDeviceId() async {
    final existing = CacheHelper.getData(key: _deviceIdKey);
    if (existing is String && existing.isNotEmpty) {
      return existing;
    }

    final id = _generateUuidV4();
    await CacheHelper.saveData(key: _deviceIdKey, value: id);
    return id;
  }

  /// FCM token when available; PMO API requires a non-empty value.
  Future<String> getFirebaseToken() async {
    final stored = CacheHelper.getData(key: _firebaseTokenKey);
    if (stored is String && stored.isNotEmpty) {
      return stored;
    }
    return '';
  }

  Future<void> setFirebaseToken(String token) async {
    if (token.isEmpty) return;
    await CacheHelper.saveData(key: _firebaseTokenKey, value: token);
  }

  String _generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String hex(int value) => value.toRadixString(16).padLeft(2, '0');
    final b = bytes.map(hex).join();
    return '${b.substring(0, 8)}-${b.substring(8, 12)}-'
        '${b.substring(12, 16)}-${b.substring(16, 20)}-${b.substring(20)}';
  }
}
