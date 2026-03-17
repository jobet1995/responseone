import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../config/themes.dart';
import '../../widgets/status_chip.dart';

class LiveTrackingScreen extends ConsumerWidget {
  final String emergencyId;

  const LiveTrackingScreen({super.key, required this.emergencyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencyState = ref.watch(emergencyHistoryProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: emergencyState.when(
        data: (history) {
          final emergency = history.firstWhere(
            (e) => e.id == emergencyId,
            orElse: () => throw Exception('Emergency not found'),
          );

          return Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Map View Placeholder'),
                        Text('Integrating with Google Maps...'),
                      ],
                    ),
                  ),
                ),
              ),
              _buildStatusPanel(context, emergency),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildStatusPanel(BuildContext context, dynamic emergency) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.defaultPadding * 1.5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emergency.type.value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              StatusChip.fromEmergencyStatus(emergency.status),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.location_on,
            'Your Location',
            'Lat: ${emergency.location.latitude.toStringAsFixed(4)}, Lng: ${emergency.location.longitude.toStringAsFixed(4)}',
          ),
          const SizedBox(height: 12),
          if (emergency.responderId != null) ...[
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.directions_car,
              'Responder assigned',
              'Estimated arrival: 5-10 mins',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                    label: const Text('CALL RESPONDER'),
                  ),
                ),
              ],
            ),
          ] else
            const Text(
              'Waiting for a responder to be assigned...',
              style: TextStyle(fontStyle: FontStyle.italic, color: AppTheme.textSecondary),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryRed),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
