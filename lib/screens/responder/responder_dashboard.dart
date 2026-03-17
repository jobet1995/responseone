import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/responder_provider.dart';
import '../../providers/emergency_provider.dart';
import '../../models/responder_model.dart';
import '../../config/themes.dart';
import '../../widgets/emergency_card.dart';
import 'package:go_router/go_router.dart';

class ResponderDashboard extends ConsumerWidget {
  const ResponderDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responderState = ref.watch(responderProvider);
    final emergencies = ref.watch(emergencyHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responder Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: responderState.when(
        data: (responder) {
          if (responder == null) {
            return const Center(child: Text('You are not registered as a responder.'));
          }

          return Column(
            children: [
              _buildAvailabilityToggle(context, ref, responder),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.read(emergencyHistoryProvider.notifier).fetchHistory(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppTheme.defaultPadding),
                    children: [
                      const Text(
                        'Active Missions',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      emergencies.when(
                        data: (list) {
                          final active = list.where((e) => e.responderId == responder.id).toList();
                          if (active.isEmpty) {
                            return _buildEmptyState('No active missions assigned.');
                          }
                          return Column(
                            children: active.map((e) => EmergencyCard(
                              emergency: e,
                              onTap: () => context.push('/responder/detail/${e.id}'),
                            )).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Recent Mission History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // Just a placeholder for history for now
                      _buildEmptyState('History view coming soon.'),
                    ],
                  ),
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

  Widget _buildAvailabilityToggle(BuildContext context, WidgetRef ref, ResponderModel responder) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryRed.withValues(alpha: 0.05),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: responder.isAvailable ? Colors.green : Colors.grey,
            radius: 6,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  responder.isAvailable ? 'YOU ARE ONLINE' : 'YOU ARE OFFLINE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: responder.isAvailable ? Colors.green : Colors.grey,
                  ),
                ),
                Text(
                  responder.isAvailable ? 'Ready for emergency calls' : 'Enable to receive missions',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: responder.isAvailable,
            activeThumbColor: Colors.green,
            activeTrackColor: Colors.green.withValues(alpha: 0.5),
            onChanged: (val) {
              ref.read(responderProvider.notifier).updateAvailability(
                val,
                val ? ResponderStatus.available : ResponderStatus.offDuty,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          message,
          style: const TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
