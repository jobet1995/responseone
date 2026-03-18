import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../providers/responder_provider.dart';
import '../../config/themes.dart';
import '../../models/emergency_model.dart';

class AssignResponderScreen extends ConsumerWidget {
  final String requestId;

  const AssignResponderScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencies = ref.watch(emergencyHistoryProvider);
    final responderState = ref.watch(responderProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Assign Responder'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: emergencies.when(
        data: (list) {
          final emergency = list.firstWhere((e) => e.id == requestId);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIncidentSummary(emergency),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'AVAILABLE RESPONDERS',
                  style: TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.bold, 
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: responderState.when(
                  data: (responder) {
                    if (responder == null) return _buildNoResponders();
                    
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildResponderTile(context, ref, emergency, responder),
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

  Widget _buildResponderTile(BuildContext context, WidgetRef ref, dynamic emergency, dynamic responder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryRed.withOpacity(0.1), width: 2),
          ),
          child: const CircleAvatar(
            backgroundColor: AppTheme.primaryRed,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        title: Text(
          'UNIT: ${responder.vehicleNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                const Text('Nearby (0.8km away)', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryRed,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('ASSIGN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        onTap: () => _handleAssignment(context, ref, emergency.id, responder.id),
      ),
    );
  }

  Widget _buildNoResponders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No responders found.', style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  void _handleAssignment(BuildContext context, WidgetRef ref, String eId, String rId) {
    ref.read(emergencyHistoryProvider.notifier).updateLocalStatus(eId, EmergencyStatus.assigned);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Responder assigned successfully!')),
    );
  }

  Widget _buildIncidentSummary(dynamic emergency) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withOpacity(0.05),
        border: const Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emergency.type.value,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${emergency.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              _buildStatusIndicator(emergency.status),
            ],
          ),
          const Divider(height: 32),
          Text(
            emergency.description,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(EmergencyStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, size: 14, color: Colors.orange),
          const SizedBox(width: 6),
          Text(
            status.value.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
