abstract class TokenStorage {
  Future<String> getToken();
  Future<void> storeToken(String token);
  Future<void> clearToken();
  //TODO: MOVE THIS FROM HERE !
  Future<int> getUserId();
  Future<void> storeUserId(int token);
}
