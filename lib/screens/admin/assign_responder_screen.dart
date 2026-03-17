import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../providers/responder_provider.dart';
import '../../config/themes.dart';
import '../../widgets/status_chip.dart';
import '../../models/emergency_model.dart';

class AssignResponderScreen extends ConsumerWidget {
  final String requestId;

  const AssignResponderScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencies = ref.watch(emergencyHistoryProvider);
    final responderState = ref.watch(responderProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Assign Responder')),
      body: emergencies.when(
        data: (list) {
          final emergency = list.firstWhere((e) => e.id == requestId);
          
          return Column(
            children: [
              _buildIncidentSummary(emergency),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Available Responders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: responderState.when(
                  data: (responder) {
                    if (responder == null) return const Center(child: Text('No responders found.'));
                    
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(responder.id), // In real app, this would be name
                          subtitle: Text('Type: ${responder.vehicleNumber}'),
                          trailing: StatusChip.fromResponderStatus(responder.status),
                          onTap: () => _handleAssignment(context, ref, emergency.id, responder.id),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _handleAssignment(BuildContext context, WidgetRef ref, String eId, String rId) {
    // Optimization: Update local state immediately
    ref.read(emergencyHistoryProvider.notifier).updateLocalStatus(eId, EmergencyStatus.assigned);
    
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Responder assigned successfully!')),
    );
  }

  Widget _buildIncidentSummary(dynamic emergency) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryRed.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emergency.type.value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              StatusChip.fromEmergencyStatus(emergency.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(emergency.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
