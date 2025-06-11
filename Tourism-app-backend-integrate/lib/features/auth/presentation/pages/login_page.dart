import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/admin/presentation/providers/provider_config.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;
  String _selectedRole = 'user';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final auth = ref.read(authStateProvider);
      final success = _isRegistering
          ? await auth.register(
              _emailController.text,
              _passwordController.text,
              role: _selectedRole,
            )
          : await auth.login(
              _emailController.text,
              _passwordController.text,
            );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.error ?? 'An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Register' : 'Login'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (_isRegistering && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_isRegistering) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(value: 'user', child: Text('User')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (authState.isLoading)
                    const CircularProgressIndicator()
                  else ...[
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(_isRegistering ? 'Register' : 'Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: Text(_isRegistering
                          ? 'Already have an account? Login'
                          : 'Need an account? Register'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
 