import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String name, String email, String password, {String role = 'user'});
  Future<void> signOut();
}
