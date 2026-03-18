import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Defines the roles available in the ResQNow system.
enum UserRole {
  citizen('Citizen'),
  responder('Responder'),
  admin('Admin');

  final String value;
  const UserRole(this.value);

  factory UserRole.fromString(String? role) {
    return UserRole.values.firstWhere(
      (e) => e.value == role,
      orElse: () => UserRole.citizen,
    );
  }
}

/// Defines the account status of a user.
enum UserStatus {
  active('Active'),
  inactive('Inactive');

  final String value;
  const UserStatus(this.value);

  factory UserStatus.fromString(String? status) {
    return UserStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => UserStatus.active,
    );
  }
}

/// Represents a coordinate (Latitude and Longitude).
@immutable
class LocationCoordinate {
  final double latitude;
  final double longitude;

  const LocationCoordinate({
    required this.latitude,
    required this.longitude,
  });

  factory LocationCoordinate.fromMap(Map<String, dynamic> map) {
    return LocationCoordinate(
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationCoordinate &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

/// Represents a user in the ResQNow application.
@immutable
class UserModel {
  /// Unique identifier.
  final String id;

  /// Full name of the user.
  final String name;

  /// Email address used for login.
  final String email;

  /// Contact phone number for emergencies.
  final String phoneNumber;

  /// Role assigned to the user (Citizen, Responder, Admin).
  final UserRole role;

  /// Current account status (Active, Inactive).
  final UserStatus status;

  /// When the account was created.
  final DateTime createdAt;

  /// last time the account was modified.
  final DateTime updatedAt;

  /// Current location of the user (Used primarily for responders).
  final LocationCoordinate? location;

  /// List of emergency IDs assigned to this user (If they are a responder).
  final List<String> assignedEmergencyIds;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.role = UserRole.citizen,
    this.status = UserStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.assignedEmergencyIds = const [],
  });

  /// Factory to create a [UserModel] from a Map (JSON).
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? map['phoneNumber'] ?? '',
      role: UserRole.fromString(map['role']),
      status: UserStatus.fromString(map['status']),
      createdAt: (map['created_at'] != null || map['createdAt'] != null)
          ? DateTime.parse(map['created_at'] ?? map['createdAt'])
          : DateTime.now(),
      updatedAt: (map['updated_at'] != null || map['updatedAt'] != null)
          ? DateTime.parse(map['updated_at'] ?? map['updatedAt'])
          : DateTime.now(),
      location: map['location'] != null 
          ? LocationCoordinate.fromMap(map['location'] is String ? jsonDecode(map['location']) : map['location']) 
          : null,
      assignedEmergencyIds: List<String>.from(
        map['assigned_emergency_ids'] ?? map['assignedEmergencyIds'] ?? []
      ),
    );
  }

  /// Converts the [UserModel] instance to a Map for JSON serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'role': role.value,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'location': location?.toMap(),
      'assigned_emergency_ids': assignedEmergencyIds,
    };
  }

  /// Creates a copy of the current [UserModel] with updated fields.
  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    UserRole? role,
    UserStatus? status,
    DateTime? updatedAt,
    LocationCoordinate? location,
    List<String>? assignedEmergencyIds,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      assignedEmergencyIds: assignedEmergencyIds ?? this.assignedEmergencyIds,
    );
  }

  // --- Helper Getters ---
  bool get isAdmin => role == UserRole.admin;
  bool get isResponder => role == UserRole.responder;
  bool get isCitizen => role == UserRole.citizen;
  bool get isActive => status == UserStatus.active;

  // --- Equality & Hashing ---
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.role == role &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.location == location &&
        listEquals(other.assignedEmergencyIds, assignedEmergencyIds);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      phoneNumber,
      role,
      status,
      createdAt,
      updatedAt,
      location,
      Object.hashAll(assignedEmergencyIds),
    );
  }
}
