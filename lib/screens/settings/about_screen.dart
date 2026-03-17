import 'package:flutter/material.dart';
import '../../config/themes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About ResQNow')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.emergency_share, size: 80, color: AppTheme.primaryRed),
            const SizedBox(height: 16),
            const Text(
              'ResQNow',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryRed),
            ),
            const Text(
              'Version 1.0.0+1',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            const Text(
              'ResQNow is a next-generation emergency response platform designed to bridge the gap between citizens in distress and first responders. Our mission is to reduce response times and save lives through real-time location tracking and intelligent mission routing.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 40),
            _buildSection(context, 'Legal', [
              _buildLinkTile(context, 'Terms of Service', () {}),
              _buildLinkTile(context, 'Privacy Policy', () {}),
              _buildLinkTile(context, 'Cookie Policy', () {}),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Support', [
              _buildLinkTile(context, 'Help Center', () {}),
              _buildLinkTile(context, 'Contact Support', () {}),
              _buildLinkTile(context, 'Send Feedback', () {}),
            ]),
            const SizedBox(height: 40),
            const Text(
              '© 2026 ResQNow Emergency Solutions Inc.\nAll Rights Reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildLinkTile(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.open_in_new, size: 16, color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }
}
