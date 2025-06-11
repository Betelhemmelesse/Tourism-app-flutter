import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tourism_app/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: authState.when(
        data: (user) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                'assets/images/avatar_placeholder.png',
              ),
            ),
          ),
          const SizedBox(height: 10),
            Center(
            child: Text(
                user?.name ?? 'Guest User',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                user?.email ?? '',
                style: const TextStyle(color: Colors.grey),
          ),
          ),
          const SizedBox(height: 30),

          const SectionTitle('Settings'),
          _buildProfileItem(Icons.manage_accounts, 'Account management'),
          _buildProfileItem(Icons.notifications_none, 'Notification'),

          const SizedBox(height: 10),
          const SectionTitle('Login'),
          _buildProfileItem(
            Icons.logout,
            'Log out',
            color: Colors.red,
            onTap: () async {
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),

          const SizedBox(height: 10),
          const SectionTitle('Support'),
          _buildProfileItem(Icons.help_outline, 'Help center'),
          _buildProfileItem(Icons.privacy_tip_outlined, 'Privacy policy'),
          _buildProfileItem(Icons.info_outline, 'About'),
          _buildProfileItem(
            Icons.feedback_outlined,
            'Feedback',
            onTap: () => context.push('/feedback'),
          ),
        ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    IconData icon,
    String title, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
    );
  }
}
