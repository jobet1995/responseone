import 'package:flutter/material.dart';
import '../../config/themes.dart';
import '../../models/emergency_model.dart';

class EmergencyButtons extends StatelessWidget {
  final Function(EmergencyType) onTypeSelected;

  const EmergencyButtons({super.key, required this.onTypeSelected});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 12.0;
        const int crossAxisCount = 3;
        final double itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        const double childAspectRatio = 0.85;
        final double itemHeight = itemWidth / childAspectRatio;

        final buttons = [
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
            'Mental\nHealth',
            Icons.psychology,
            Colors.purple,
            EmergencyType.mentalHealth,
          ),
          _buildButton(
            context,
            'Other',
            Icons.report_problem,
            Colors.grey,
            EmergencyType.other,
          ),
        ];

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: buttons.map((button) => SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: button,
          )).toList(),
        );
      },
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
