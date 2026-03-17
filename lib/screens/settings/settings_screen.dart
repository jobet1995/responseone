import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        children: [
          _buildSectionHeader('General'),
          _buildSettingsTile(
            context,
            Icons.notifications_outlined,
            'Notifications',
            'Manage push and in-app alerts',
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          _buildSettingsTile(
            context,
            Icons.dark_mode_outlined,
            'Dark Mode',
            'Toggle application theme',
            trailing: Switch(value: false, onChanged: (_) {}),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Account & Privacy'),
          _buildSettingsTile(
            context,
            Icons.lock_outline,
            'Change Password',
            'Update your login credentials',
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
            Icons.security_outlined,
            'Privacy Policy',
            'Read our terms of service',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildSettingsTile(
            context,
            Icons.info_outline,
            'Version',
            'ResQNow v1.0.0+1',
            onTap: () => context.push('/settings/about'),
          ),
          _buildSettingsTile(
            context,
            Icons.help_outline,
            'Help & Support',
            'Contact our team for assistance',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryRed,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.textPrimary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }
}
