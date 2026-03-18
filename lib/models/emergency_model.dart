import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'user_model.dart'; // For LocationCoordinate

/// Defines the types of emergencies supported by the system.
enum EmergencyType {
  medical('Medical'),
  fire('Fire'),
  police('Police'),
  mentalHealth('Mental Health'),
  walkWithMe('Walk With Me'),
  other('Other');

  final String value;
  const EmergencyType(this.value);

  factory EmergencyType.fromString(String? type) {
    return EmergencyType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => EmergencyType.other,
    );
  }
}

/// Defines the various states an emergency request can be in.
enum EmergencyStatus {
  pending('Pending'),
  assigned('Assigned'),
  enRoute('EnRoute'),
  arrived('Arrived'),
  completed('Completed'),
  cancelled('Cancelled');

  final String value;
  const EmergencyStatus(this.value);

  factory EmergencyStatus.fromString(String? status) {
    return EmergencyStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => EmergencyStatus.pending,
    );
  }
}

/// Represents an emergency request in the ResQNow application.
@immutable
class EmergencyModel {
  /// Unique identifier.
  final String id;

  /// ID of the citizen who reported the emergency.
  final String citizenId;

  /// ID of the responder assigned to this emergency (if any).
  final String? responderId;

  /// Category of the emergency.
  final EmergencyType type;

  /// Current status of the emergency response.
  final EmergencyStatus status;

  /// Brief description provided by the citizen.
  final String description;

  /// Exact location where the emergency was reported.
  final LocationCoordinate location;

  /// List of media URLs (images/videos) attached to the report.
  final List<String> mediaUrls;

  /// Timestamp when the request was first created.
  final DateTime createdAt;

  /// Timestamp when the request was last updated.
  final DateTime updatedAt;

  /// Timestamp when a responder was assigned.
  final DateTime? assignedAt;

  /// Timestamp when the emergency was marked as completed.
  final DateTime? completedAt;

  const EmergencyModel({
    required this.id,
    required this.citizenId,
    this.responderId,
    required this.type,
    required this.status,
    this.description = '',
    required this.location,
    this.mediaUrls = const [],
    required this.createdAt,
    required this.updatedAt,
    this.assignedAt,
    this.completedAt,
  });

  /// Factory to create an [EmergencyModel] from a Map (JSON).
  factory EmergencyModel.fromMap(Map<String, dynamic> map) {
    return EmergencyModel(
      id: map['id'] ?? '',
      citizenId: map['citizen_id'] ?? map['citizenId'] ?? '',
      responderId: (map['responder_id'] ?? map['responderId']) as String?,
      type: EmergencyType.fromString(map['type']),
      status: EmergencyStatus.fromString(map['status']),
      description: map['description'] ?? '',
      location: map['location'] != null 
          ? LocationCoordinate.fromMap(map['location'] is String ? jsonDecode(map['location']) : map['location']) 
          : const LocationCoordinate(latitude: 0, longitude: 0),
      mediaUrls: List<String>.from(map['media_urls'] ?? map['mediaUrls'] ?? []),
      createdAt: (map['created_at'] != null || map['createdAt'] != null)
          ? DateTime.parse(map['created_at'] ?? map['createdAt'])
          : DateTime.now(),
      updatedAt: (map['updated_at'] != null || map['updatedAt'] != null)
          ? DateTime.parse(map['updated_at'] ?? map['updatedAt'])
          : DateTime.now(),
      assignedAt: (map['assigned_at'] ?? map['assignedAt']) != null 
          ? DateTime.parse(map['assigned_at'] ?? map['assignedAt']) 
          : null,
      completedAt: (map['completed_at'] ?? map['completedAt']) != null 
          ? DateTime.parse(map['completed_at'] ?? map['completedAt']) 
          : null,
    );
  }

  /// Converts the [EmergencyModel] instance to a Map for JSON serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'citizen_id': citizenId,
      'responder_id': responderId,
      'type': type.value,
      'status': status.value,
      'description': description,
      'location': location.toMap(),
      'media_urls': mediaUrls,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'assigned_at': assignedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Creates a copy of the current [EmergencyModel] with updated fields.
  EmergencyModel copyWith({
    String? responderId,
    EmergencyType? type,
    EmergencyStatus? status,
    String? description,
    LocationCoordinate? location,
    List<String>? mediaUrls,
    DateTime? updatedAt,
    DateTime? assignedAt,
    DateTime? completedAt,
  }) {
    return EmergencyModel(
      id: id,
      citizenId: citizenId,
      responderId: responderId ?? this.responderId,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
      location: location ?? this.location,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedAt: assignedAt ?? this.assignedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // --- Helper Getters ---
  bool get isPending => status == EmergencyStatus.pending;
  bool get isAssigned => status == EmergencyStatus.assigned;
  bool get isEnRoute => status == EmergencyStatus.enRoute;
  bool get isArrived => status == EmergencyStatus.arrived;
  bool get isCompleted => status == EmergencyStatus.completed;
  bool get isCancelled => status == EmergencyStatus.cancelled;

  bool get hasResponder => responderId != null && responderId!.isNotEmpty;

  // --- Equality & Hashing ---
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmergencyModel &&
        other.id == id &&
        other.citizenId == citizenId &&
        other.responderId == responderId &&
        other.type == type &&
        other.status == status &&
        other.description == description &&
        other.location == location &&
        listEquals(other.mediaUrls, mediaUrls) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.assignedAt == assignedAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      citizenId,
      responderId,
      type,
      status,
      description,
      location,
      Object.hashAll(mediaUrls),
      createdAt,
      updatedAt,
      assignedAt,
      completedAt,
    );
  }
}
