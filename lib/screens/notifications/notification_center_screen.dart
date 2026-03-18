import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/themes.dart';
import 'package:intl/intl.dart';

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends ConsumerState<NotificationCenterScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      final history = await NotificationService.instance.getNotificationHistory(user.id);
      if (mounted) {
        setState(() {
          _notifications = history;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 64, color: AppTheme.textSecondary),
                      SizedBox(height: 16),
                      Text('No notifications yet', style: TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getNotificationColor(notification.type).withOpacity(0.1),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: _getNotificationColor(notification.type),
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.body),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, h:mm a').format(notification.createdAt),
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                      trailing: !notification.isRead 
                        ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primaryRed, shape: BoxShape.circle))
                        : null,
                      onTap: () {
                        if (!notification.isRead) {
                          NotificationService.instance.markAsRead(notification.id);
                          setState(() {
                            // Update local state for immediate feedback
                            _notifications[index] = NotificationModel(
                              id: notification.id,
                              userId: notification.userId,
                              title: notification.title,
                              body: notification.body,
                              type: notification.type,
                              isRead: true,
                              createdAt: notification.createdAt,
                            );
                          });
                        }
                      },
                    );
                  },
                ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.emergency: return Icons.emergency;
      case NotificationType.alert: return Icons.warning_amber_rounded;
      case NotificationType.system: return Icons.settings_suggest;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.emergency: return AppTheme.primaryRed;
      case NotificationType.alert: return Colors.orange;
      case NotificationType.system: return Colors.blue;
    }
  }
}
