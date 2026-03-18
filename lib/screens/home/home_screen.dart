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
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push('/notifications'),
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
              _buildSafetyAlerts(context),
              const SizedBox(height: 32),
              const Text(
                'Request Emergency Help',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              EmergencyButtons(
                onTypeSelected: (type) {
                  context.push('/request', extra: type);
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
                            Icon(Icons.history, size: 48, color: Colors.grey.withOpacity(0.3)),
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
                        onTap: () => context.push('/tracking/${history[index].id}'),
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
        onPressed: () => context.push('/request'),
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

  Widget _buildSafetyAlerts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Safety Alerts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAlertCard(
                context,
                'Severe Weather',
                'Heavy rain expected in your area. Stay indoors.',
                Icons.thunderstorm,
                Colors.orange,
              ),
              const SizedBox(width: 12),
              _buildAlertCard(
                context,
                'Safety Workshop',
                'Join our First Aid training this Saturday.',
                Icons.school,
                AppTheme.secondaryBlue,
              ),
              const SizedBox(width: 12),
              _buildAlertCard(
                context,
                'Emergency Kit',
                'Is your emergency kit ready? Check our guide.',
                Icons.backpack,
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard(BuildContext context, String title, String desc, IconData icon, Color color) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
