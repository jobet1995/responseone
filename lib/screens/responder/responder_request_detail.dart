import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_provider.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';
import '../../models/emergency_model.dart';

class ResponderRequestDetail extends ConsumerWidget {
  final String requestId;

  const ResponderRequestDetail({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencyState = ref.watch(emergencyHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mission Details'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: emergencyState.when(
        data: (history) {
          final emergency = history.firstWhere(
            (e) => e.id == requestId,
            orElse: () => throw Exception('Mission not found'),
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusBanner(emergency),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(emergency),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Incident Description'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          emergency.description.isEmpty ? 'No description provided.' : emergency.description,
                          style: const TextStyle(fontSize: 15, height: 1.5, color: AppTheme.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Location & Navigation'),
                      const SizedBox(height: 12),
                      _buildLocationCard(),
                      const SizedBox(height: 48),
                      _buildActionButtons(context, ref, emergency),
                      const SizedBox(height: 24),
                      _buildBottomActions(),
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

  Widget _buildStatusBanner(dynamic emergency) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      color: _getStatusColor(emergency.status).withOpacity(0.1),
      child: Row(
        children: [
          Icon(_getStatusIcon(emergency.status), color: _getStatusColor(emergency.status), size: 20),
          const SizedBox(width: 12),
          Text(
            'STATUS: ${emergency.status.value.toUpperCase()}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getStatusColor(emergency.status),
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic emergency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emergency.type.value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'INCIDENT #${emergency.id.substring(0, 8).toUpperCase()}',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryRed.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.emergency_rounded, color: AppTheme.primaryRed, size: 32),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        image: const DecorationImage(
          image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=14&size=400x400&key=YOUR_API_KEY'),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: AppTheme.primaryRed, size: 40),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                  ),
                  child: const Text('View on Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, dynamic emergency) {
    if (emergency.status == EmergencyStatus.assigned) {
      return CustomButton(
        text: 'START NAVIGATION',
        onPressed: () => _updateStatus(ref, emergency.id, EmergencyStatus.enRoute),
        icon: Icons.navigation_rounded,
      );
    }
    if (emergency.status == EmergencyStatus.enRoute) {
      return CustomButton(
        text: 'I HAVE ARRIVED',
        onPressed: () => _updateStatus(ref, emergency.id, EmergencyStatus.arrived),
        icon: Icons.location_on_rounded,
        backgroundColor: Colors.teal[600],
      );
    }
    if (emergency.status == EmergencyStatus.arrived) {
      return CustomButton(
        text: 'COMPLETE MISSION',
        onPressed: () => _updateStatus(ref, emergency.id, EmergencyStatus.completed),
        icon: Icons.check_circle_rounded,
        backgroundColor: Colors.green[600],
      );
    }
    return const SizedBox.shrink();
  }

  void _updateStatus(WidgetRef ref, String id, EmergencyStatus status) {
    ref.read(emergencyHistoryProvider.notifier).updateLocalStatus(id, status);
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded, size: 18),
            label: const Text('CALL DISPATCH'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
            label: const Text('REPORT ISSUE', style: TextStyle(color: Colors.orange)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Colors.orange),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        letterSpacing: 1.2,
      ),
    );
  }

  Color _getStatusColor(EmergencyStatus status) {
    switch (status) {
      case EmergencyStatus.pending: return Colors.orange;
      case EmergencyStatus.assigned: return Colors.blue;
      case EmergencyStatus.enRoute: return Colors.purple;
      case EmergencyStatus.arrived: return Colors.teal;
      case EmergencyStatus.completed: return Colors.green;
      case EmergencyStatus.cancelled: return Colors.red;
    }
  }

  IconData _getStatusIcon(EmergencyStatus status) {
    switch (status) {
      case EmergencyStatus.pending: return Icons.timer_outlined;
      case EmergencyStatus.assigned: return Icons.person_outline;
      case EmergencyStatus.enRoute: return Icons.directions_run_rounded;
      case EmergencyStatus.arrived: return Icons.location_on_outlined;
      case EmergencyStatus.completed: return Icons.check_circle_outline;
      case EmergencyStatus.cancelled: return Icons.cancel_outlined;
    }
  }
}
