import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/location_service.dart';
import 'dart:async';

class MapState {
  final Set<Marker> markers;
  final LocationCoordinate? userLocation;
  final bool isLoading;

  MapState({
    this.markers = const {},
    this.userLocation,
    this.isLoading = false,
  });

  MapState copyWith({
    Set<Marker>? markers,
    LocationCoordinate? userLocation,
    bool? isLoading,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      userLocation: userLocation ?? this.userLocation,
      isLoading: isLoading ?? this.isLoading,
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
        final locMap = data['current_location'] as Map<String, dynamic>;
        final lat = (locMap['latitude'] as num).toDouble();
        final lng = (locMap['longitude'] as num).toDouble();
        
        newMarkers.add(
          Marker(
            markerId: MarkerId('responder_${data['id']}'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: '${data['name']} (${data['type']})'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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
        final locMap = data['location'] as Map<String, dynamic>;
        final lat = (locMap['latitude'] as num).toDouble();
        final lng = (locMap['longitude'] as num).toDouble();

        newMarkers.add(
          Marker(
            markerId: MarkerId('emergency_${data['id']}'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: '${data['type']} Emergency'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }

      state = state.copyWith(markers: newMarkers.toSet());
    } catch (e) {
      print('Error fetching map markers: $e');
    }
  }

  void updateUserLocation(LocationCoordinate location) {
    state = state.copyWith(userLocation: location);
  }
}

final mapProvider = NotifierProvider<MapNotifier, MapState>(MapNotifier.new);
