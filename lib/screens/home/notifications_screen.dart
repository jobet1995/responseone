import 'package:flutter/material.dart';
import '../../config/themes.dart';
import '../../utils/extensions/date_time_extensions.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock notifications for now
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Emergency Update',
        'body': 'Responder is now en-route to your location.',
        'time': DateTime.now().subtract(const Duration(minutes: 5)),
        'type': 'alert',
      },
      {
        'title': 'New Safety Tip',
        'body': 'Learn how to handle medical emergencies during earthquakes.',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'type': 'info',
      },
      {
        'title': 'System Update',
        'body': 'Service maintenance scheduled for tonight at 12:00 AM.',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'system',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notify = notifications[index];
          return _buildNotificationItem(context, notify);
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, Map<String, dynamic> notify) {
    final type = notify['type'];
    final icon = type == 'alert' ? Icons.warning_amber : (type == 'info' ? Icons.info_outline : Icons.settings_outlined);
    final color = type == 'alert' ? AppTheme.primaryRed : (type == 'info' ? AppTheme.secondaryBlue : Colors.grey);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notify['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      (notify['time'] as DateTime).timeAgo,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notify['body'],
                  style: const TextStyle(color: AppTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
