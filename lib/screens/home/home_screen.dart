import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../providers/emergency_provider.dart';
import '../../config/themes.dart';
import '../../widgets/emergency_card.dart';
import 'emergency_buttons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final emergencyHistory = ref.watch(emergencyHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ResQNow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(currentUserProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(emergencyHistoryProvider.notifier).fetchHistory(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user?.name ?? 'User'),
              const SizedBox(height: 24),
              const Text(
                'Request Emergency Help',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              EmergencyButtons(
                onTypeSelected: (type) {
                  context.push('/home/request', extra: type);
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Recent Emergencies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              emergencyHistory.when(
                data: (history) {
                  if (history.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.history, size: 48, color: Colors.grey.withValues(alpha: 0.3)),
                            const SizedBox(height: 8),
                            const Text(
                              'No recent emergencies',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return EmergencyCard(
                        emergency: history[index],
                        onTap: () => context.push('/home/tracking/${history[index].id}'),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/home/request'),
        label: const Text('QUICK HELP'),
        icon: const Icon(Icons.emergency),
        backgroundColor: AppTheme.primaryRed,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $name!',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Stay safe. We are here to help.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
