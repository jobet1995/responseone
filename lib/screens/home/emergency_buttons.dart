import 'package:flutter/material.dart';
import '../../config/themes.dart';
import '../../models/emergency_model.dart';

class EmergencyButtons extends StatelessWidget {
  final Function(EmergencyType) onTypeSelected;

  const EmergencyButtons({super.key, required this.onTypeSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildButton(
          context,
          'Medical',
          Icons.medical_services,
          Colors.blue,
          EmergencyType.medical,
        ),
        _buildButton(
          context,
          'Fire',
          Icons.local_fire_department,
          Colors.orange,
          EmergencyType.fire,
        ),
        _buildButton(
          context,
          'Police',
          Icons.local_police,
          Colors.blueGrey,
          EmergencyType.police,
        ),
        _buildButton(
          context,
          'Other',
          Icons.report_problem,
          Colors.grey,
          EmergencyType.other,
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    EmergencyType type,
  ) {
    return InkWell(
      onTap: () => onTypeSelected(type),
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
