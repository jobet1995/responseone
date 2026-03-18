import 'package:flutter/material.dart';
import '../../config/themes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildAppLogo(),
            const SizedBox(height: 16),
            const Text(
              'ResQNow',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryRed, letterSpacing: 1),
            ),
            const Text(
              'VERSION 1.0.0 (BUILD 102)',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: const Text(
                'ResQNow is an advanced emergency response ecosystem. We leverage real-time data to connect people in critical situations with the help they need, instantly.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppTheme.textPrimary, height: 1.6),
              ),
            ),
            const SizedBox(height: 48),
            _buildSection(context, 'Legal & Compliance', [
              _buildLinkTile(context, 'Terms of Service', Icons.description_outlined, () {}),
              _buildLinkTile(context, 'Privacy Policy', Icons.privacy_tip_outlined, () {}),
              _buildLinkTile(context, 'Cookie Policy', Icons.cookie_outlined, () {}),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Community & Support', [
              _buildLinkTile(context, 'Help Center', Icons.help_outline_rounded, () {}),
              _buildLinkTile(context, 'Contact Us', Icons.mail_outline_rounded, () {}),
              _buildLinkTile(context, 'Our Mission', Icons.favorite_border_rounded, () {}),
            ]),
            const SizedBox(height: 64),
            const Text(
              '© 2026 ResQNow Systems.\nAll rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.1), width: 1),
      ),
      child: const Icon(Icons.emergency_share_rounded, size: 64, color: AppTheme.primaryRed),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> tiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(children: tiles),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20, color: AppTheme.textPrimary),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }
}
