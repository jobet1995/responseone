import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../config/themes.dart';
import '../../widgets/emergency_card.dart';
import 'package:go_router/go_router.dart';

class EmergencyHistoryScreen extends ConsumerWidget {
  const EmergencyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencies = ref.watch(emergencyHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Emergency History')),
      body: emergencies.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text(
                    'No emergency requests found.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(emergencyHistoryProvider.notifier).fetchHistory(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.defaultPadding),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final emergency = list[index];
                return EmergencyCard(
                  emergency: emergency,
                  onTap: () => context.push('/home/tracking/${emergency.id}'),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
