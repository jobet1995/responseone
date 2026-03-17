import 'package:flutter/foundation.dart';

/// Central constants for the ResQNow Emergency Response App.
/// This file contains all non-sensitive configuration, 
/// status codes, and other values used throughout the application.
class AppConstants {
  AppConstants._();

  // --- General App Constants ---
  static const String appName = 'ResQNow';
  static const String appVersion = '1.0.0';
  
  // Date/Time Formats
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String timeFormat = 'HH:mm';
  static const String dateFormat = 'MMM dd, yyyy';

  // Network & Requests
  static const int maxRetries = 3;
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const Duration splashDelay = Duration(seconds: 2);
}

/// Defined user roles within the ResQNow ecosystem.
class UserRoles {
  UserRoles._();

  static const String citizen = 'citizen';
  static const String responder = 'responder';
  static const String admin = 'admin';
}

/// Status codes representing the lifecycle of an emergency request.
class EmergencyStatus {
  EmergencyStatus._();

  static const String pending = 'pending';
  static const String assigned = 'assigned';
  static const String enRoute = 'en_route';
  static const String arrived = 'arrived';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
}

/// Categories of emergencies supported by the platform.
class EmergencyTypes {
  EmergencyTypes._();

  static const String medical = 'medical';
  static const String fire = 'fire';
  static const String police = 'police';
  static const String other = 'other';
}

/// Different types of notifications sent to users and responders.
class NotificationTypes {
  NotificationTypes._();

  static const String newEmergency = 'new_emergency';
  static const String responderAssigned = 'responder_assigned';
  static const String statusUpdate = 'status_update';
}

/// REST API Endpoints.
class ApiEndpoints {
  ApiEndpoints._();

  // Change base URL based on environment
  static const String baseUrl = kReleaseMode 
      ? 'https://api.resqnow.com/v1' 
      : 'https://staging-api.resqnow.com/v1';

  static const String emergencies = '/emergencies';
  static const String responders = '/responders';
  static const String users = '/users';
  static const String notifications = '/notifications';
}

/// Constants related to Google Maps and Geolocation.
class MapConstants {
  MapConstants._();

  // Default camera position (e.g., Manila, Philippines)
  static const double defaultLatitude = 14.5995;
  static const double defaultLongitude = 120.9842;
  static const double defaultZoom = 14.0;
  static const double responderZoom = 16.0;

  // Location update settings
  static const int locationUpdateIntervalMs = 5000; // 5 seconds
  static const int fastestLocationUpdateIntervalMs = 2000; // 2 seconds
  static const double locationDistanceFilter = 5.0; // 5 meters
}
