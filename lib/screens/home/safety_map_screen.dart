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

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final userPos = mapState.userLocation;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Safety Map'),
        backgroundColor: Colors.white.withOpacity(0.8),
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
                initialCenter: LatLng(userPos?.latitude ?? 0, userPos?.longitude ?? 0),
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.resqnow.app',
                ),
                MarkerLayer(markers: mapState.markers),
              ],
            ),
          ),
          
          if (mapState.isLoading)
            const Center(child: CircularProgressIndicator()),

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
                          color: Colors.black.withOpacity(0.1),
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
                      _buildFilterChip('All', true),
                      _buildFilterChip('Hospitals', false),
                      _buildFilterChip('Police', false),
                      _buildFilterChip('Responders', false),
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

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {},
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
