import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/location_service.dart';
import 'dart:async';

class MapState {
  final List<Marker> markers; // active incidents/responders
  final List<Marker> directoryMarkers; // hospitals, police, etc.
  final LocationCoordinate? userLocation;
  final bool isLoading;
  final String? errorMessage;

  // Manila as a sensible default if location is totally unavailable
  static const defaultLocation = LocationCoordinate(latitude: 14.5995, longitude: 120.9842);

  MapState({
    this.markers = const [],
    this.directoryMarkers = const [],
    this.userLocation,
    this.isLoading = false,
    this.errorMessage,
  });

  MapState copyWith({
    List<Marker>? markers,
    List<Marker>? directoryMarkers,
    LocationCoordinate? userLocation,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      directoryMarkers: directoryMarkers ?? this.directoryMarkers,
      userLocation: userLocation ?? this.userLocation,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MapNotifier extends Notifier<MapState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Timer? _refreshTimer;
  StreamSubscription<LocationCoordinate>? _locationSubscription;

  @override
  MapState build() {
    initMap();
    
    // Set up periodic marker refresh (responders/emergencies)
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => refreshMarkers());
    
    // Set up real-time user location tracking
    _locationSubscription = LocationService.instance.getLocationStream().listen(
      (location) => updateUserLocation(location),
      onError: (e) => debugPrint('MapNotifier: Location stream error: $e'),
    );
    
    ref.onDispose(() {
      _refreshTimer?.cancel();
      _locationSubscription?.cancel();
    });

    return MapState(isLoading: true);
  }

  Future<void> initMap() async {
    // Get initial user location
    try {
      final location = await LocationService.instance.getCurrentLocation();
      if (location == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Could not determine your location. Please ensure GPS is ON and permissions are granted.',
        );
      } else {
        state = state.copyWith(userLocation: location, isLoading: false, errorMessage: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error initializing map location');
    }

    // Fetch initial markers
    await refreshMarkers();
  }

  /// Manually force a location refresh
  Future<void> refreshLocation() async {
    final location = await LocationService.instance.getCurrentLocation();
    if (location != null) {
      updateUserLocation(location);
    }
  }

  Future<void> refreshMarkers() async {
    final List<Marker> incidentMarkers = [];
    final List<Marker> dirMarkers = [];

    try {
      // 1. Fetch Responders & Emergencies (Incident Markers)
      final respondersData = await _supabase.from('responders').select().eq('is_available', true);
      for (var data in respondersData) {
        final locMap = data['current_location'] as Map<String, dynamic>?;
        if (locMap == null) continue;
        final lat = (locMap['latitude'] as num?)?.toDouble();
        final lng = (locMap['longitude'] as num?)?.toDouble();
        if (lat == null || lng == null) continue;
        incidentMarkers.add(
          Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: const Icon(Icons.directions_car, color: Colors.blue, size: 30),
          ),
        );
      }

      final emergenciesData = await _supabase
          .from('emergencies')
          .select()
          .not('status', 'eq', 'Completed')
          .not('status', 'eq', 'Cancelled');
      
      for (var data in emergenciesData) {
        final locMap = data['location'] as Map<String, dynamic>?;
        if (locMap == null) continue;
        final lat = (locMap['latitude'] as num?)?.toDouble();
        final lng = (locMap['longitude'] as num?)?.toDouble();
        if (lat == null || lng == null) continue;
        incidentMarkers.add(
          Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: const Icon(Icons.location_on, color: Colors.red, size: 35),
          ),
        );
      }

      // 2. Fetch Directory Markers (Hospitals, Police - Mocked for Demo)
      // In a real app, this would call a Places API or a specific Supabase table
      final userLocation = state.userLocation;
      if (userLocation != null) {
        dirMarkers.addAll([
          _createDirectoryMarker(
            userLocation.latitude + 0.005, 
            userLocation.longitude + 0.005, 
            Icons.local_hospital, 
            Colors.green,
            'City Hospital',
          ),
          _createDirectoryMarker(
            userLocation.latitude - 0.008, 
            userLocation.longitude - 0.003, 
            Icons.local_police, 
            Colors.blueGrey,
            'Central Police Station',
          ),
          _createDirectoryMarker(
            userLocation.latitude + 0.002, 
            userLocation.longitude - 0.007, 
            Icons.local_fire_department, 
            Colors.orange,
            'Fire Station 1',
          ),
        ]);
      }

      state = state.copyWith(
        markers: incidentMarkers, 
        directoryMarkers: dirMarkers,
        errorMessage: null,
      );
    } catch (e) {
      debugPrint('Error fetching map markers: $e');
      state = state.copyWith(errorMessage: 'Failed to load some map data');
    }
  }

  Marker _createDirectoryMarker(double lat, double lng, IconData icon, Color color, String name) {
    return Marker(
      point: LatLng(lat, lng),
      width: 45,
      height: 45,
      child: GestureDetector(
        onTap: () {
          // Future: Show info window
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
      ),
    );
  }

  void updateUserLocation(LocationCoordinate location) {
    bool firstLocation = state.userLocation == null;
    state = state.copyWith(userLocation: location);
    if (firstLocation) {
      refreshMarkers(); // Refresh to place directory markers relative to user
    }
  }
}

final mapProvider = NotifierProvider<MapNotifier, MapState>(MapNotifier.new);
