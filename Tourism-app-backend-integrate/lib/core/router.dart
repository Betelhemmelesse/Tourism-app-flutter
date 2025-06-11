import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tourism_app/features/destination/presentation/screens/home_screen.dart';
import 'package:tourism_app/shared/screens/feedback_screen.dart';
import 'package:tourism_app/shared/widgets/main_scaffold.dart';
import 'package:tourism_app/features/admin/presentation/pages/admin_page.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/admin/presentation/providers/provider_config.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';
      final isSignUpRoute = state.matchedLocation == '/signup';

      // If not logged in and not on auth routes, redirect to login
      if (!isLoggedIn && !isLoginRoute && !isSignUpRoute) {
        return '/login';
      }

      // If logged in and on auth routes, redirect to home
      if (isLoggedIn && (isLoginRoute || isSignUpRoute)) {
        if (authState.user?['role'] == 'admin') {
          return '/admin';
        }
        return '/main';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: '/feedback',
        builder: (context, state) => const FeedbackScreen(),
      ),
    ],
  );
});
