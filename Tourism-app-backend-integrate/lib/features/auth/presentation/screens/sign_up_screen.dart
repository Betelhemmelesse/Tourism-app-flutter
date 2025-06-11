import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (prev, next) {
      next.whenOrNull(
        loading: () => setState(() => _isLoading = true),
        data: (_) {
          setState(() => _isLoading = false);
          context.go('/main');
        },
        error: (err, _) {
          setState(() {
            _isLoading = false;
            _error = err.toString();
          });
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
                      controller: _nameController,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(color: primaryColor),
                          labelText: 'Full Name',
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
                            return 'Please enter your name';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                    ),
                    const SizedBox(height: 60),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
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
                                    setState(() => _error = null);
                                    ref.read(authProvider.notifier).signup(
                                      _nameController.text.trim(),
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              }
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                              'Login',
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
