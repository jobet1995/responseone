import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../config/themes.dart';
import '../../providers/map_provider.dart';

class SafetyMapScreen extends ConsumerStatefulWidget {
  const SafetyMapScreen({super.key});

  @override
  ConsumerState<SafetyMapScreen> createState() => _SafetyMapScreenState();
}

class _SafetyMapScreenState extends ConsumerState<SafetyMapScreen> {
  final MapController _mapController = MapController();

  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final userPos = mapState.userLocation;

    // Filter markers based on selected category
    List<Marker> activeDirectoryMarkers = [];
    if (_selectedCategory == 'All') {
      activeDirectoryMarkers = mapState.directoryMarkers;
    } else {
      activeDirectoryMarkers = mapState.directoryMarkers.where((m) {
        if (m.child is! GestureDetector) return false;
        final icon = (m.child as GestureDetector).child;
        if (icon is! Container) return false;
        final actualIcon = icon.child;
        if (actualIcon is! Icon) return false;
        
        if (_selectedCategory == 'Hospitals') return actualIcon.icon == Icons.local_hospital;
        if (_selectedCategory == 'Police') return actualIcon.icon == Icons.local_police;
        if (_selectedCategory == 'Fire Stations') return actualIcon.icon == Icons.local_fire_department;
        return false;
      }).toList();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Safety Map'),
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.primaryRed),
            onPressed: () => ref.read(mapProvider.notifier).refreshMarkers(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // The Map fills the entire screen
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  userPos?.latitude ?? MapState.defaultLocation.latitude,
                  userPos?.longitude ?? MapState.defaultLocation.longitude,
                ),
                initialZoom: userPos == null ? 10.0 : 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.resqnow.app',
                ),
                MarkerLayer(markers: activeDirectoryMarkers),
                MarkerLayer(markers: mapState.markers),
                if (userPos != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(userPos.latitude, userPos.longitude),
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 30),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          
          if (mapState.isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryRed),
                    SizedBox(height: 16),
                    Text('Fetching your location...', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),

          if (userPos == null && !mapState.isLoading)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_off, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        mapState.errorMessage ?? 'Location unavailable. Showing default map.',
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Search and Filter Overlay
          SafeArea(
            child: Column(
              children: [
                // Premium Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for hospitals, police...',
                        prefixIcon: Icon(Icons.search, color: AppTheme.primaryRed),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Categories / Filters
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Hospitals'),
                      _buildFilterChip('Police'),
                      _buildFilterChip('Fire Stations'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userPos != null) {
            _mapController.move(
              LatLng(userPos.latitude, userPos.longitude),
              14.0,
            );
          }
        },
        backgroundColor: AppTheme.primaryRed,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedCategory == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = label;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryRed,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppTheme.primaryRed : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
