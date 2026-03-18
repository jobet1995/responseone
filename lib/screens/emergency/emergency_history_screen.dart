import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../config/themes.dart';
import '../../widgets/emergency_card.dart';
import 'package:go_router/go_router.dart';
import '../../models/emergency_model.dart';

class _EmergencyHistoryScreenState extends ConsumerState<EmergencyHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emergencies = ref.watch(emergencyHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Incident History'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: emergencies.when(
        data: (list) {
          if (list.isEmpty) return _buildEmptyState();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildHistoryList(list),
              _buildHistoryList(list.where((e) => e.status == EmergencyStatus.pending).toList()),
              _buildHistoryList(list.where((e) => [EmergencyStatus.assigned, EmergencyStatus.enRoute, EmergencyStatus.arrived].contains(e.status)).toList()),
              _buildHistoryList(list.where((e) => [EmergencyStatus.completed, EmergencyStatus.cancelled].contains(e.status)).toList()),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHistoryList(List<EmergencyModel> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('No incidents in this category.', style: TextStyle(color: AppTheme.textSecondary)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(emergencyHistoryProvider.notifier).fetchHistory(),
      color: AppTheme.primaryRed,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final emergency = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EmergencyCard(
              emergency: emergency,
              onTap: () => context.push('/tracking/${emergency.id}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_rounded, size: 64, color: AppTheme.primaryRed.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          const Text(
            'No history found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your emergency request history will\nappear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class EmergencyHistoryScreen extends ConsumerStatefulWidget {
  const EmergencyHistoryScreen({super.key});

  @override
  ConsumerState<EmergencyHistoryScreen> createState() => _EmergencyHistoryScreenState();
}
