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
            onPressed: () => context.push('/profile/edit'),
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
                GestureDetector(
                  onTap: () => context.push('/profile/edit'),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.primaryRed.withOpacity(0.1),
                        backgroundImage: user.avatarUrl.isNotEmpty 
                            ? NetworkImage(user.avatarUrl) 
                            : null,
                        child: user.avatarUrl.isEmpty 
                            ? const Icon(Icons.person, size: 80, color: AppTheme.primaryRed) 
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
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
                    color: AppTheme.secondaryBlue.withOpacity(0.1),
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
                  _buildInfoTile(
                    context,
                    Icons.medical_services_outlined,
                    'Medical Profile',
                    'Blood type, Allergies, etc.',
                    onTap: () => context.push('/profile/medical'),
                  ),
                  _buildInfoTile(
                    context,
                    Icons.contact_phone_outlined,
                    'Emergency Contacts',
                    'Trusted contacts',
                    onTap: () => context.push('/profile/contacts'),
                  ),
                  _buildInfoTile(context, Icons.calendar_today_outlined, 'Member Since', 'March 2026'),
                ]),
                const SizedBox(height: 24),
                _buildVolunteerSection(context, ref, user),
                const SizedBox(height: 16),
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
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      trailing: onTap != null ? const Icon(Icons.chevron_right, size: 20) : null,
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildVolunteerSection(BuildContext context, WidgetRef ref, dynamic user) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: const BorderSide(color: AppTheme.secondaryBlue, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volunteer_activism_outlined, color: AppTheme.secondaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Volunteer Mode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.secondaryBlue),
                ),
                const Spacer(),
                Switch(
                  value: user.isVolunteer,
                  onChanged: (v) {
                    // Update volunteer status
                    ref.read(currentUserProvider.notifier).updateUser(user.copyWith(isVolunteer: v));
                  },
                  activeColor: AppTheme.secondaryBlue,
                ),
              ],
            ),
            if (user.isVolunteer) ...[
              const Divider(),
              const Text(
                'Help your community! You will be notified of nearby emergencies where you can provide basic assistance.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              Text(
                'Skills: ${user.skills.isEmpty ? "None added" : user.skills}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
