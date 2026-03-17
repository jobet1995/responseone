import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_chip.dart';
import '../../models/emergency_model.dart';

class ResponderRequestDetail extends ConsumerWidget {
  final String requestId;

  const ResponderRequestDetail({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencyState = ref.watch(emergencyHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mission Details')),
      body: emergencyState.when(
        data: (history) {
          final emergency = history.firstWhere(
            (e) => e.id == requestId,
            orElse: () => throw Exception('Mission not found'),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(emergency),
                const Divider(height: 48),
                _buildSectionTitle('Incident Description'),
                const SizedBox(height: 8),
                Text(
                  emergency.description.isEmpty ? 'No description provided.' : emergency.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Location'),
                const SizedBox(height: 12),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: const Center(child: Text('Map Location Placeholder')),
                ),
                const SizedBox(height: 48),
                if (emergency.status == EmergencyStatus.assigned)
                  CustomButton(
                    text: 'START NAVIGATION',
                    onPressed: () {
                      ref.read(emergencyHistoryProvider.notifier).updateLocalStatus(
                        emergency.id,
                        EmergencyStatus.enRoute,
                      );
                    },
                    icon: Icons.navigation_outlined,
                  ),
                if (emergency.status == EmergencyStatus.enRoute)
                  CustomButton(
                    text: 'I HAVE ARRIVED',
                    onPressed: () {
                      ref.read(emergencyHistoryProvider.notifier).updateLocalStatus(
                        emergency.id,
                        EmergencyStatus.arrived,
                      );
                    },
                    icon: Icons.location_on,
                    backgroundColor: Colors.teal,
                  ),
                if (emergency.status == EmergencyStatus.arrived)
                  CustomButton(
                    text: 'COMPLETE MISSION',
                    onPressed: () {
                      ref.read(emergencyHistoryProvider.notifier).updateLocalStatus(
                        emergency.id,
                        EmergencyStatus.completed,
                      );
                    },
                    icon: Icons.check_circle_outline,
                    backgroundColor: Colors.green,
                  ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  label: const Text('REPORT ISSUE', style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader(dynamic emergency) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emergency.type.value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'ID: ${emergency.id.substring(0, 8)}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            StatusChip.fromEmergencyStatus(emergency.status),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}
