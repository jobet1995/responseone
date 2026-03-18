import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/location_service.dart';
import 'dart:async';

class MapState {
  final List<Marker> markers;
  final LocationCoordinate? userLocation;
  final bool isLoading;
  final String? errorMessage;

  // Manila as a sensible default if location is totally unavailable
  static const defaultLocation = LocationCoordinate(latitude: 14.5995, longitude: 120.9842);

  MapState({
    this.markers = const [],
    this.userLocation,
    this.isLoading = false,
    this.errorMessage,
  });

  MapState copyWith({
    List<Marker>? markers,
    LocationCoordinate? userLocation,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      userLocation: userLocation ?? this.userLocation,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MapNotifier extends Notifier<MapState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Timer? _refreshTimer;

  @override
  MapState build() {
    initMap();
    
    // Set up periodic refresh
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => refreshMarkers());
    
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    return MapState(isLoading: true);
  }

  Future<void> initMap() async {
    // Get initial user location
    final location = await LocationService.instance.getCurrentLocation();
    state = state.copyWith(userLocation: location, isLoading: false);

    // Fetch initial markers
    await refreshMarkers();
  }

  Future<void> refreshMarkers() async {
    final List<Marker> newMarkers = [];

    try {
      // 1. Fetch Responders
      final respondersData = await _supabase.from('responders').select().eq('is_available', true);
      for (var data in respondersData) {
        final locMap = data['current_location'] as Map<String, dynamic>?;
        if (locMap == null) continue;

        final lat = (locMap['latitude'] as num?)?.toDouble();
        final lng = (locMap['longitude'] as num?)?.toDouble();
        
        if (lat == null || lng == null) continue;
        
        newMarkers.add(
          Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: const Icon(
              Icons.directions_car,
              color: Colors.blue,
              size: 30,
            ),
          ),
        );
      }

      // 2. Fetch Active Emergencies
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

        newMarkers.add(
          Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 35,
            ),
          ),
        );
      }

      state = state.copyWith(markers: newMarkers, errorMessage: null);
    } catch (e) {
      debugPrint('Error fetching map markers: $e');
      state = state.copyWith(errorMessage: 'Failed to load some map data');
    }
  }

  void updateUserLocation(LocationCoordinate location) {
    state = state.copyWith(userLocation: location);
  }
}

final mapProvider = NotifierProvider<MapNotifier, MapState>(MapNotifier.new);
