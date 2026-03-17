import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Edit profile logic
            },
          ),
        ],
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppTheme.primaryRed.withValues(alpha: 0.1),
                      child: const Icon(Icons.person, size: 80, color: AppTheme.primaryRed),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.secondaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildInfoCard(context, [
                  _buildInfoTile(context, Icons.phone_outlined, 'Phone', user.phoneNumber),
                  _buildInfoTile(context, Icons.location_on_outlined, 'Address', 'Manila, Philippines'),
                  _buildInfoTile(context, Icons.calendar_today_outlined, 'Member Since', 'March 2026'),
                ]),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'LOGOUT',
                  onPressed: () async {
                    await ref.read(currentUserProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  backgroundColor: Colors.grey[200],
                  style: CustomButtonStyle.outlined,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Delete account logic
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      dense: true,
    );
  }
}
