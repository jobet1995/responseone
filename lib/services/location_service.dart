import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user_model.dart'; // For LocationCoordinate

/// Service to handle device location permissions and tracking.
class LocationService {
  LocationService._();
  
  static final LocationService instance = LocationService._();

  /// Checks if location services are enabled and permissions are granted.
  Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('LocationService: Location services are disabled');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Gets the current position of the device.
  Future<LocationCoordinate?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      debugPrint('LocationService: Permission not granted');
      return null;
    }

    try {
      // Use a timeout to avoid hanging indefinitely if GPS signal is weak
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return LocationCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('LocationService: Error getting location: $e');
      // Fallback to last known position if current is unavailable
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          return LocationCoordinate(
            latitude: lastPosition.latitude,
            longitude: lastPosition.longitude,
          );
        }
      } catch (_) {}
      return null;
    }
  }

  /// Returns a stream of location updates.
  /// Useful for responders tracking their own position in real-time.
  Stream<LocationCoordinate> getLocationStream({
    int intervalMs = 5000,
    int distanceFilter = 10,
  }) {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (position) => LocationCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  /// Opens the device's location settings.
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
