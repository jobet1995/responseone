import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Aid Guide')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        children: [
          _buildCategory(
            context,
            'Basic Life Support',
            [
              _buildGuideItem(context, 'CPR', 'Push hard and fast in the center of the chest.'),
              _buildGuideItem(context, 'Choking', 'Perform abdominal thrusts (Heimlich maneuver).'),
            ],
            Icons.favorite,
            Colors.red,
          ),
          const SizedBox(height: 24),
          _buildCategory(
            context,
            'Injury & Trauma',
            [
              _buildGuideItem(context, 'Heavy Bleeding', 'Apply direct pressure to the wound.'),
              _buildGuideItem(context, 'Burns', 'Cool the burn with cool (not cold) running water.'),
              _buildGuideItem(context, 'Fractures', 'Keep the injured area still and supported.'),
            ],
            Icons.healing,
            Colors.orange,
          ),
          const SizedBox(height: 24),
          _buildCategory(
            context,
            'Medical Emergencies',
            [
              _buildGuideItem(context, 'Seizures', 'Clear the area and protect the person\'s head.'),
              _buildGuideItem(context, 'Heart Attack', 'Have the person sit down and stay calm.'),
              _buildGuideItem(context, 'Stroke', 'Think F.A.S.T (Face, Arms, Speech, Time).'),
            ],
            Icons.medical_services,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    String title,
    List<Widget> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildGuideItem(BuildContext context, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed(
          AppRouteNames.firstAidDetail,
          pathParameters: {'title': title},
        ),
      ),
    );
  }
}
