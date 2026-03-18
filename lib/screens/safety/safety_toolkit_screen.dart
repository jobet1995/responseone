import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../models/emergency_model.dart';

class SafetyToolkitScreen extends StatefulWidget {
  const SafetyToolkitScreen({super.key});

  @override
  State<SafetyToolkitScreen> createState() => _SafetyToolkitScreenState();
}

class _SafetyToolkitScreenState extends State<SafetyToolkitScreen> {
  bool _isSirenActive = false;
  bool _isFlashActive = false;

  void _toggleSiren() {
    setState(() => _isSirenActive = !_isSirenActive);
    // In a real app: ref.read(soundServiceProvider).playSiren();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSirenActive ? 'Siren Activated' : 'Siren Deactivated'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleFlash() {
    setState(() => _isFlashActive = !_isFlashActive);
    // In a real app: ref.read(flashServiceProvider).toggleSosPattern();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFlashActive ? 'SOS Flashlight Activated' : 'Flashlight Deactivated'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Safety Toolkit'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'EMERGENCY QUICK ACTIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildToolkitCard(
              title: 'SOS Siren',
              subtitle: 'Plays a loud alarm sound to attract attention.',
              icon: Icons.volume_up_rounded,
              color: Colors.red,
              isActive: _isSirenActive,
              onTap: _toggleSiren,
            ),
            const SizedBox(height: 16),
            _buildToolkitCard(
              title: 'SOS Flashlight',
              subtitle: 'Blinks the camera flash in SOS Morse pattern.',
              icon: Icons.flashlight_on_rounded,
              color: Colors.amber,
              isActive: _isFlashActive,
              onTap: _toggleFlash,
            ),
            const SizedBox(height: 32),
            const Text(
              'PERSONAL SAFETY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              title: 'Fake Call',
              subtitle: 'Receive a simulated call to exit a situation.',
              icon: Icons.phone_callback_rounded,
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fake Call feature coming soon!')),
                );
              },
            ),
            _buildActionTile(
              title: 'Share Location',
              subtitle: 'Send real-time GPS to trusted contacts.',
              icon: Icons.share_location_rounded,
              color: Colors.green,
              onTap: () => context.push('/profile/contacts'),
            ),
            _buildActionTile(
              title: 'Walk With Me',
              subtitle: 'Keep a responder on the line until you reach home.',
              icon: Icons.directions_walk_rounded,
              color: Colors.purple,
              onTap: () => context.push('/request', extra: EmergencyType.other),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryRed.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.shield_rounded, size: 48, color: AppTheme.primaryRed),
                  const SizedBox(height: 16),
                  const Text(
                    'Stay Safe with ResQNow',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use these tools proactively. Your safety is our top priority.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolkitCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: isActive ? color : Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 48,
              color: isActive ? Colors.white : color,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? Colors.white.withValues(alpha: 0.8) : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }
}
