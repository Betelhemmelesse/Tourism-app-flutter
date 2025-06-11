import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            // Navigate based on user type
            if (user.role == 'admin') {
              context.go('/admin');
            } else {
          context.go('/main');
            }
          }
        },
        error: (err, _) {
          setState(() => _error = err.toString());
        },
      );
    });

    final primaryColor = const Color(0XFF43b0f1);
    final borderRadius = BorderRadius.circular(20);

    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/login_header.jpg',
                  height: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: primaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(color: primaryColor),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: borderRadius,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: primaryColor,
                        obscureText: true,
                        decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(color: primaryColor),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: borderRadius,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) =>
                                value!.length < 6
                                    ? 'Password must be 6+ characters'
                                    : null,
                      ),
                      const SizedBox(height: 60),
                      authState.maybeWhen(
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        orElse: () => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: borderRadius,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                ref.read(authProvider.notifier).login(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                },
                                child: const Text(
                                  'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () => context.go('/signup'),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
