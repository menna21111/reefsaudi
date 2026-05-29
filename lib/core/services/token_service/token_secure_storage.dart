import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_storage.dart';


class TokenFlutterSecureStorageService implements TokenStorage {
  final FlutterSecureStorage _preferences;

  const TokenFlutterSecureStorageService(this._preferences);

  @override
  Future<String> getToken() async {
    var token = await _preferences.read(key: 'token');
    log(token.toString());
    return await _preferences.read(key: 'token') ?? '';
  }

  @override
  Future<void> storeToken(String token) async {
    await _preferences.write(key: 'token', value: token);
  }

  @override
  Future<int> getUserId() async {
    var val = await _preferences.read(key: 'userId') ?? "0";
    return int.tryParse(val) ?? 0;
  }

  @override
  Future<void> storeUserId(int id) async {
    await _preferences.write(key: 'userId', value: id.toString());
  }

  @override
  Future<void> clearToken() async {
    await _preferences.delete(key: 'token');
    await _preferences.delete(key: 'userId');
  }
}
