import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../config/routes.dart';
import 'dart:convert';

/// Service to handle push and local notifications.
class NotificationService {
  NotificationService._();
  
  static final NotificationService instance = NotificationService._();

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
        // Assume payload can be a direct route string or a JSON object
        if (payload.startsWith('{')) {
          final Map<String, dynamic> data = jsonDecode(payload);
          final String? route = data['route'];
          if (route != null) {
            AppRouter.router.push(route);
          }
        } else {
          // Fallback to direct route strings
          AppRouter.router.push(payload);
        }
      } catch (e) {
        debugPrint('Error handling notification tap: $e');
      }
    }
  }

  /// Displays an immediate local notification.
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    bool isUrgent = false,
  }) async {
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
  }

  /// Requests permissions for iOS and Android (Version 13+).
  Future<bool?> requestPermissions() async {
    return await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
}
