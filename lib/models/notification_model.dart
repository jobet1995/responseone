import 'package:flutter/foundation.dart';

enum NotificationType {
  emergency('Emergency'),
  alert('Alert'),
  system('System');

  final String value;
  const NotificationType(this.value);

  factory NotificationType.fromString(String? type) {
    return NotificationType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => NotificationType.system,
    );
  }
}

@immutable
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: NotificationType.fromString(map['type']),
      isRead: map['is_read'] ?? map['isRead'] ?? false,
      createdAt: (map['created_at'] != null || map['createdAt'] != null)
          ? DateTime.parse(map['created_at'] ?? map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type.value,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    bool? isRead,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
