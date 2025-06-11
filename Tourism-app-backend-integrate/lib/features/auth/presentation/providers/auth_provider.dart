import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/auth/domain/usecases/sign_out_usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'usecase_providers.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) => AuthNotifier(
    ref.read(signInUsecaseProvider),
    ref.read(signupUseCaseProvider),
    ref.read(signOutUseCaseProvider),
  ),
);

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final SignInUsecase loginUseCase;
  final SignUpUsecase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  AuthNotifier(this.loginUseCase, this.signUpUseCase, this.signOutUseCase)
    : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await loginUseCase.call(email, password);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(String name, String email, String password, {String role = 'user'}) async {
    state = const AsyncValue.loading();
    try {
      final result = await signUpUseCase.call(name, email, password, role: role);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await signOutUseCase.call();
    state = const AsyncValue.data(null);
  }
}
