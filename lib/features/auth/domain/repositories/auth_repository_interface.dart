abstract class AuthRepositoryInterface {
  Future<void> login(String email, String password);
  Future<void> register(Map<String, dynamic> data);
  Future<void> logout(String token);
}
