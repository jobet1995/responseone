import 'package:flutter/foundation.dart';
import 'user_model.dart'; // For LocationCoordinate

/// Defines the types of responder vehicles/teams.
enum ResponderType {
  ambulance('Ambulance'),
  fireTruck('FireTruck'),
  policeCar('PoliceCar'),
  rescueVan('RescueVan'),
  other('Other');

  final String value;
  const ResponderType(this.value);

  factory ResponderType.fromString(String? type) {
    return ResponderType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => ResponderType.other,
    );
  }
}

/// Defines the current operational status of a responder.
enum ResponderStatus {
  available('Available'),
  busy('Busy'),
  onBreak('OnBreak'),
  offDuty('OffDuty');

  final String value;
  const ResponderStatus(this.value);

  factory ResponderStatus.fromString(String? status) {
    return ResponderStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => ResponderStatus.available,
    );
  }
}

/// Represents a responder (emergency personnel/vehicle) in the ResQNow application.
@immutable
class ResponderModel {
  /// Unique identifier.
  final String id;

  /// The associated user account ID.
  final String userId;

  /// Name of the responder or team.
  final String name;

  /// License plate or vehicle identification number.
  final String vehicleNumber;

  /// Category of the responder (Ambulance, FireTruck, etc.).
  final ResponderType type;

  /// Current operational status.
  final ResponderStatus status;

  /// Whether the responder is ready to accept new emergencies.
  final bool isAvailable;

  /// Current GPS coordinates of the responder.
  final LocationCoordinate? currentLocation;

  /// Average user rating (0.0 to 5.0).
  final double rating;

  /// Total number of emergencies handled.
  final int totalResponses;

  /// The ID of the emergency currently being handled (if any).
  final String? activeEmergencyId;

  const ResponderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.vehicleNumber,
    required this.type,
    required this.status,
    required this.isAvailable,
    this.currentLocation,
    this.rating = 0.0,
    this.totalResponses = 0,
    this.activeEmergencyId,
  });

  /// Factory to create a [ResponderModel] from a Map (JSON).
  factory ResponderModel.fromMap(Map<String, dynamic> map) {
    return ResponderModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      name: map['name'] ?? '',
      vehicleNumber: map['vehicle_number'] ?? map['vehicleNumber'] ?? '',
      type: ResponderType.fromString(map['type']),
      status: ResponderStatus.fromString(map['status']),
      isAvailable: map['is_available'] ?? map['isAvailable'] ?? false,
      currentLocation: (map['current_location'] != null || map['currentLocation'] != null)
          ? LocationCoordinate.fromMap(map['current_location'] ?? map['currentLocation']) 
          : null,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalResponses: (map['total_responses'] ?? map['totalResponses']) as int? ?? 0,
      activeEmergencyId: (map['active_emergency_id'] ?? map['activeEmergencyId']) as String?,
    );
  }

  /// Converts the [ResponderModel] instance to a Map for JSON serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'vehicle_number': vehicleNumber,
      'type': type.value,
      'status': status.value,
      'is_available': isAvailable,
      'current_location': currentLocation?.toMap(),
      'rating': rating,
      'total_responses': totalResponses,
      'active_emergency_id': activeEmergencyId,
    };
  }

  /// Creates a copy of the current [ResponderModel] with updated fields.
  ResponderModel copyWith({
    String? name,
    String? vehicleNumber,
    ResponderType? type,
    ResponderStatus? status,
    bool? isAvailable,
    LocationCoordinate? currentLocation,
    double? rating,
    int? totalResponses,
    String? activeEmergencyId,
  }) {
    return ResponderModel(
      id: id,
      userId: userId,
      name: name ?? this.name,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      rating: rating ?? this.rating,
      totalResponses: totalResponses ?? this.totalResponses,
      activeEmergencyId: activeEmergencyId ?? this.activeEmergencyId,
    );
  }

  // --- Helper Getters ---
  bool get isOnMission => activeEmergencyId != null && activeEmergencyId!.isNotEmpty;
  bool get isBusy => status == ResponderStatus.busy;
  bool get isOffDuty => status == ResponderStatus.offDuty;

  // --- Equality & Hashing ---
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResponderModel &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.vehicleNumber == vehicleNumber &&
        other.type == type &&
        other.status == status &&
        other.isAvailable == isAvailable &&
        other.currentLocation == currentLocation &&
        other.rating == rating &&
        other.totalResponses == totalResponses &&
        other.activeEmergencyId == activeEmergencyId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      name,
      vehicleNumber,
      type,
      status,
      isAvailable,
      currentLocation,
      rating,
      totalResponses,
      activeEmergencyId,
    );
  }
}
