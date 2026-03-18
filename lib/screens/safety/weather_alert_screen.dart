import 'package:flutter/material.dart';
import '../../config/themes.dart';

class WeatherAlertScreen extends StatelessWidget {
  const WeatherAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Weather Alert'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlertHeader(),
            Padding(
              padding: const EdgeInsets.all(AppTheme.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Current Situation'),
                  const SizedBox(height: 12),
                  const Text(
                    'A severe thunderstorm warning has been issued for your current location. Heavy rainfall, strong winds, and potential flooding are expected over the next 3-6 hours.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Safety Recommendations'),
                  const SizedBox(height: 12),
                  _buildSafetyTip(
                    Icons.home_rounded,
                    'Stay Indoors',
                    'Avoid unnecessary travel and stay inside a sturdy building.',
                  ),
                  _buildSafetyTip(
                    Icons.electrical_services_rounded,
                    'Unplug Appliances',
                    'Protect your electronics from potential power surges.',
                  ),
                  _buildSafetyTip(
                    Icons.window_rounded,
                    'Stay Away from Windows',
                    'Move to an interior room to avoid potential flying debris.',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Emergency Contacts'),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    'Local Emergency Services',
                    '911',
                    Icons.phone_in_talk_rounded,
                    Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    'Weather Bureau Hotline',
                    '1-800-WEATHER',
                    Icons.info_outline_rounded,
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.thunderstorm_rounded, color: Colors.white, size: 64),
          SizedBox(height: 16),
          Text(
            'SEVERE THUNDERSTORM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Active Warning: High Risk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildSafetyTip(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryRed, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String name, String number, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(number, style: const TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.call, color: color),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
