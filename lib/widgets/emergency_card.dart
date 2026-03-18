import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/emergency_model.dart';
import '../config/themes.dart';
import 'status_chip.dart';

class EmergencyCard extends StatelessWidget {
  final EmergencyModel emergency;
  final VoidCallback onTap;

  const EmergencyCard({
    super.key,
    required this.emergency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _getTypeIcon(emergency.type),
                      const SizedBox(width: 8),
                      Text(
                        emergency.type.value,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  StatusChip.fromEmergencyStatus(emergency.status),
                ],
              ),
              const SizedBox(height: 12),
              if (emergency.description.isNotEmpty) ...[
                Text(
                  emergency.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
              const Divider(),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        timeFormat.format(emergency.createdAt),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(emergency.createdAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (emergency.responderId != null)
                    const Row(
                      children: [
                        Icon(Icons.directions_run, size: 14, color: AppTheme.secondaryBlue),
                        SizedBox(width: 4),
                        Text(
                          'Responder On Way',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTypeIcon(EmergencyType type) {
    IconData iconData;
    Color color;

    switch (type) {
      case EmergencyType.medical:
        iconData = Icons.medical_services;
        color = Colors.blue;
        break;
      case EmergencyType.fire:
        iconData = Icons.local_fire_department;
        color = Colors.orange;
        break;
      case EmergencyType.police:
        iconData = Icons.local_police;
        color = Colors.blueGrey;
        break;
      case EmergencyType.mentalHealth:
        iconData = Icons.psychology;
        color = Colors.purple;
        break;
      case EmergencyType.other:
        iconData = Icons.report_problem;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 18, color: color),
    );
  }
}
