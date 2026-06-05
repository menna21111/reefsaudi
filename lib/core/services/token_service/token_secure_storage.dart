import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_storage.dart';

class TokenFlutterSecureStorageService implements TokenStorage {
  final FlutterSecureStorage _preferences;

  const TokenFlutterSecureStorageService(this._preferences);

  @override
  Future<String?> getToken() async {
    final token = await _preferences.read(key: 'token');
    log('TokenStorage - token: $token');
    if (token == null || token.isEmpty || token == 'null') return null;
    return token;
  }

  @override
  Future<void> storeToken(String token) async {
    await _preferences.write(key: 'token', value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    final token = await _preferences.read(key: 'refreshToken');
    if (token == null || token.isEmpty || token == 'null') return null;
    return token;
  }

  @override
  Future<void> storeRefreshToken(String token) async {
    await _preferences.write(key: 'refreshToken', value: token);
  }

  @override
  Future<String?> getUserId() async {
    return _preferences.read(key: 'userId');
  }

  @override
  Future<void> storeUserId(String id) async {
    await _preferences.write(key: 'userId', value: id);
  }

  @override
  Future<int> getLegacyUserId() async {
    final val = await _preferences.read(key: 'legacyUserId') ?? '0';
    return int.tryParse(val) ?? 0;
  }

  @override
  Future<void> storeLegacyUserId(int id) async {
    await _preferences.write(key: 'legacyUserId', value: id.toString());
  }

  @override
  Future<void> clearToken() async {
    await _preferences.delete(key: 'token');
    await _preferences.delete(key: 'refreshToken');
    await _preferences.delete(key: 'userId');
    await _preferences.delete(key: 'legacyUserId');
  }
}