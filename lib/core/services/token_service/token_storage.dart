abstract class TokenStorage {
  Future<String?> getToken(); // ← String? مش String
  Future<void> storeToken(String token);
  Future<String?> getRefreshToken();
  Future<void> storeRefreshToken(String token);
  Future<DateTime?> getTokenExpiresAt();
  Future<void> storeTokenExpiresAt(String expiresIn);
  Future<String?> getUserId();
  Future<void> storeUserId(String id);
  Future<int> getLegacyUserId();
  Future<void> storeLegacyUserId(int id);
  Future<void> clearToken();
}