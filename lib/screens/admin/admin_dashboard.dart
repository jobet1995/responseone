import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../config/themes.dart';
import '../../widgets/emergency_card.dart';
import '../../models/emergency_model.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencies = ref.watch(emergencyHistoryProvider);
    // In a real app, this would be a global stream of all emergencies, 
    // but for now we use the same history provider for demo.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: emergencies.when(
        data: (list) {
          final pending = list.where((e) => e.status == EmergencyStatus.pending).toList();
          final active = list.where((e) => e.status != EmergencyStatus.pending && e.status != EmergencyStatus.completed).toList();

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'PENDING'),
                    Tab(text: 'ACTIVE'),
                  ],
                  labelColor: AppTheme.primaryRed,
                  indicatorColor: AppTheme.primaryRed,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildEmergencyList(context, pending, 'No pending requests.'),
                      _buildEmergencyList(context, active, 'No active incidents.'),
                    ],
                  ),
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

  Widget _buildEmergencyList(BuildContext context, List<dynamic> items, String emptyMsg) {
    if (items.isEmpty) {
      return Center(child: Text(emptyMsg, style: const TextStyle(color: AppTheme.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.defaultPadding),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return EmergencyCard(
          emergency: item,
          onTap: () => context.push('/admin/assign/${item.id}'),
        );
      },
    );
  }
}
