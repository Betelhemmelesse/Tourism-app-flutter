import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/auth/domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_repository_provider.dart';

final signInUsecaseProvider = Provider<SignInUsecase>(
  (ref) => SignInUsecase(ref.read(authRepositoryProvider)),
);

final signupUseCaseProvider = Provider<SignUpUsecase>(
  (ref) => SignUpUsecase(ref.read(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});
