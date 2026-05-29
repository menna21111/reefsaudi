

import 'storage_operations.dart';

class StorageService {
  final StorageOperations _storage;

  const StorageService(this._storage);

  Future<String> read(String key) async {
    return await _storage.read(key);
  }

  Future<void> write(String key, String value) async {
    _storage.write(key, value);
  }

  Future<void> delete(String key) async {
    _storage.delete(key);
  }
}
