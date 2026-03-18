import 'package:flutter/foundation.dart';

@immutable
class EmergencyContactModel {
  final String id;
  final String userId;
  final String name;
  final String relationship;
  final String phoneNumber;
  final DateTime createdAt;

  const EmergencyContactModel({
    required this.id,
    required this.userId,
    required this.name,
    this.relationship = '',
    required this.phoneNumber,
    required this.createdAt,
  });

  factory EmergencyContactModel.fromMap(Map<String, dynamic> map) {
    return EmergencyContactModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phoneNumber: map['phone_number'] ?? map['phoneNumber'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'relationship': relationship,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
