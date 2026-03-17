import 'package:flutter/material.dart';
import '../config/themes.dart';
import '../models/emergency_model.dart';
import '../models/responder_model.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  /// Factory to create a chip from an [EmergencyStatus].
  factory StatusChip.fromEmergencyStatus(EmergencyStatus status) {
    Color color;
    switch (status) {
      case EmergencyStatus.pending:
        color = AppTheme.primaryRed;
        break;
      case EmergencyStatus.assigned:
        color = AppTheme.secondaryBlue;
        break;
      case EmergencyStatus.enRoute:
        color = AppTheme.accentOrange;
        break;
      case EmergencyStatus.arrived:
        color = Colors.teal;
        break;
      case EmergencyStatus.completed:
        color = Colors.green;
        break;
      case EmergencyStatus.cancelled:
        color = Colors.grey;
        break;
    }
    return StatusChip(label: status.value, color: color);
  }

  /// Factory to create a chip from a [ResponderStatus].
  factory StatusChip.fromResponderStatus(ResponderStatus status) {
    Color color;
    switch (status) {
      case ResponderStatus.available:
        color = Colors.green;
        break;
      case ResponderStatus.busy:
        color = AppTheme.primaryRed;
        break;
      case ResponderStatus.onBreak:
        color = AppTheme.accentOrange;
        break;
      case ResponderStatus.offDuty:
        color = Colors.grey;
        break;
    }
    return StatusChip(label: status.value, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
