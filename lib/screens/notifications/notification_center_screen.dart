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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all as read', style: TextStyle(color: AppTheme.primaryRed)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  color: AppTheme.primaryRed,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      final bool showDivider = index < _notifications.length - 1;
                      
                      return Column(
                        children: [
                          _NotificationTile(
                            notification: notification,
                            onTap: () => _markAsRead(index),
                          ),
                          if (showDivider)
                            const Divider(height: 1, indent: 72, endIndent: 16),
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded, size: 64, color: AppTheme.primaryRed.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Keep it up!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'You don\'t have any new notifications\nat the moment.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() async {
    for (var n in _notifications) {
      if (!n.isRead) NotificationService.instance.markAsRead(n.id);
    }
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
  }

  void _markAsRead(int index) {
    final notification = _notifications[index];
    if (!notification.isRead) {
      NotificationService.instance.markAsRead(notification.id);
      setState(() {
        _notifications[index] = notification.copyWith(isRead: true);
      });
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : AppTheme.primaryRed.withOpacity(0.03),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIcon(), color: _getColor(), size: 24),
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
                        _getTypeLabel(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getColor(),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        _formatTime(notification.createdAt),
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 24),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppTheme.primaryRed, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.emergency: return Icons.emergency_rounded;
      case NotificationType.alert: return Icons.warning_amber_rounded;
      case NotificationType.system: return Icons.info_outline_rounded;
    }
  }

  Color _getColor() {
    switch (notification.type) {
      case NotificationType.emergency: return AppTheme.primaryRed;
      case NotificationType.alert: return Colors.orange[700]!;
      case NotificationType.system: return Colors.blue[700]!;
    }
  }

  String _getTypeLabel() {
    return notification.type.value.toUpperCase();
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return DateFormat('MMM d').format(date);
  }
}
