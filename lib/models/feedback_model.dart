import 'package:flutter/foundation.dart';

/// Represents feedback provided by a citizen for a responder after an emergency.
@immutable
class FeedbackModel {
  final String id;
  final String emergencyId;
  final String citizenId;
  final String responderId;
  final int rating; // 1 to 5
  final String comment;
  final DateTime createdAt;

  const FeedbackModel({
    required this.id,
    required this.emergencyId,
    required this.citizenId,
    required this.responderId,
    required this.rating,
    this.comment = '',
    required this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] ?? '',
      emergencyId: map['emergency_id'] ?? map['emergencyId'] ?? '',
      citizenId: map['citizen_id'] ?? map['citizenId'] ?? '',
      responderId: map['responder_id'] ?? map['responderId'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
      comment: map['comment'] ?? '',
      createdAt: (map['created_at'] != null || map['createdAt'] != null)
          ? DateTime.parse(map['created_at'] ?? map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emergency_id': emergencyId,
      'citizen_id': citizenId,
      'responder_id': responderId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
