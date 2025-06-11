import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../providers/admin_provider.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../core/auth/auth_provider.dart';
import '../../../../core/providers/shared_providers.dart';
import 'package:tourism_app/features/hotel/presentation/providers/hotel_repository_provider.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthService(prefs);
});

// Auth state provider
final authStateProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthProvider(authService);
});

// API Service provider with auth token
final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiService(
    baseUrl: 'http://localhost:3000/api',
    getToken: () => authService.getToken() ?? '',
  );
});

// Admin repository provider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final hotelRepository = ref.watch(hotelRepositoryProvider);
  return AdminRepository(hotelRepository);
});

// Admin state provider
final adminProvider = ChangeNotifierProvider<AdminProvider>((ref) {
  return AdminProvider(ref.watch(adminRepositoryProvider));
}); 