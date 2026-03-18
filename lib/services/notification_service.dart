import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/routes.dart';
import '../models/notification_model.dart';
import 'dart:convert';

/// Service to handle push, local, and in-app historical notifications.
class NotificationService {
  NotificationService._();
  
  static final NotificationService instance = NotificationService._();

  SupabaseClient get _supabase => Supabase.instance.client;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service with platform-specific settings.
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Callback when a user taps on a notification.
  void _onNotificationTapped(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      try {
        if (payload.startsWith('{')) {
          final Map<String, dynamic> data = jsonDecode(payload);
          final String? route = data['route'];
          if (route != null) {
            AppRouter.router.push(route);
          }
        } else {
          AppRouter.router.push(payload);
        }
      } catch (e) {
        debugPrint('Error handling notification tap: $e');
      }
    }
  }

  /// Displays an immediate local notification and optionally saves it to Supabase.
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    bool isUrgent = false,
    String? userId,
    NotificationType type = NotificationType.system,
  }) async {
    // 1. Show Local Notification
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      isUrgent ? 'urgent_channel' : 'general_channel',
      isUrgent ? 'Urgent Alerts' : 'General Notifications',
      importance: isUrgent ? Importance.max : Importance.defaultImportance,
      priority: isUrgent ? Priority.high : Priority.defaultPriority,
      showWhen: true,
      playSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );

    // 2. Save to Supabase (if userId provided)
    if (userId != null) {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'body': body,
        'type': type.value,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Fetches notification history for a user.
  Future<List<NotificationModel>> getNotificationHistory(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List data = response as List;
      return data.map((json) => NotificationModel.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Marks a specific notification as read.
  Future<void> markAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  /// Requests permissions for iOS and Android (Version 13+).
  Future<bool?> requestPermissions() async {
    return await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
}
