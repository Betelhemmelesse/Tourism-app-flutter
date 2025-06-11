import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<User> call(String name, String email, String password, {String role = 'user'}) {
    return repository.signUp(name, email, password, role: role);
  }
}
