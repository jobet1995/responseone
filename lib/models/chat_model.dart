import 'package:flutter/foundation.dart';

@immutable
class MessageModel {
  final String id;
  final String emergencyId;
  final String senderId;
  final String text;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.emergencyId,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      emergencyId: map['emergency_id'] ?? map['emergencyId'] ?? '',
      senderId: map['sender_id'] ?? map['senderId'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['created_at'] != null || map['createdAt'] != null)
          ? DateTime.parse(map['created_at'] ?? map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emergency_id': emergencyId,
      'sender_id': senderId,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? text,
  }) {
    return MessageModel(
      id: id,
      emergencyId: emergencyId,
      senderId: senderId,
      text: text ?? this.text,
      createdAt: createdAt,
    );
  }
}
