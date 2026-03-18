import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader('Preferences'),
          _buildSettingsTile(
            context,
            Icons.notifications_active_outlined,
            'Push Notifications',
            'Stay updated with real-time alerts',
            trailing: Switch(
              value: true, 
              onChanged: (_) {},
              activeColor: AppTheme.primaryRed,
            ),
          ),
          _buildSettingsTile(
            context,
            Icons.location_on_outlined,
            'Location Services',
            'Required for emergency response',
            trailing: Switch(
              value: true, 
              onChanged: (_) {},
              activeColor: AppTheme.primaryRed,
            ),
          ),
          _buildSettingsTile(
            context,
            Icons.dark_mode_outlined,
            'Appearance',
            'System / Light / Dark',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Safety & Security'),
          _buildSettingsTile(
            context,
            Icons.fingerprint_rounded,
            'Biometric Login',
            'Secure your account with Face/Touch ID',
            trailing: Switch(
              value: false, 
              onChanged: (_) {},
              activeColor: AppTheme.primaryRed,
            ),
          ),
          _buildSettingsTile(
            context,
            Icons.shield_outlined,
            'Emergency Broadcast',
            'Enable sharing with nearby users',
            trailing: Switch(
              value: true, 
              onChanged: (_) {},
              activeColor: AppTheme.primaryRed,
            ),
          ),
          _buildSettingsTile(
            context,
            Icons.lock_reset_rounded,
            'Update Password',
            'Keep your account secure',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Support & Info'),
          _buildSettingsTile(
            context,
            Icons.info_outline_rounded,
            'About ResQNow',
            'Version, mission, and legal info',
            onTap: () => context.push('/settings/about'),
          ),
          _buildSettingsTile(
            context,
            Icons.help_center_outlined,
            'Help Center',
            'FAQs and contact support',
            onTap: () {},
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.primaryRed),
                ),
              ),
              child: const Text('LOG OUT', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryRed.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryRed, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios_rounded, size: 14) : null),
        onTap: onTap,
      ),
    );
  }
}
