abstract class BaseAuthRepository {
  Future<void> login(String email, String password);
}