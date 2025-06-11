import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository repository;

  SignInUsecase(this.repository);

  Future<User> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
