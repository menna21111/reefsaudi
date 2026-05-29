
abstract class StorageOperations {
  Future<String> read(String key);
  void write(String key, String value);
  void delete(String key);
}