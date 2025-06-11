import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> signIn(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<User> signUp(String name, String email, String password, {String role = 'user'}) {
    return remoteDataSource.signup(name, email, password, role: role);
  }

  @override
  Future<void> signOut() => remoteDataSource.signOut();
}
