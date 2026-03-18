import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';

class PreparednessScreen extends StatelessWidget {
  const PreparednessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Emergency Preparedness'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        children: [
          _buildHeroCard(),
          const SizedBox(height: 32),
          const Text(
            'ACTIVE CHECKLISTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildChecklistTile(
            context,
            title: 'Fire Evacuation',
            subtitle: 'Critical steps for safety during a fire.',
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            progress: 0.0,
            categoryId: 'fire',
          ),
          _buildChecklistTile(
            context,
            title: 'Flood Preparedness',
            subtitle: 'Protect your home and family from rising water.',
            icon: Icons.water_drop_rounded,
            color: Colors.blue,
            progress: 0.3,
            categoryId: 'flood',
          ),
          _buildChecklistTile(
            context,
            title: 'Earthquake Safety',
            subtitle: 'Drop, Cover, and Hold On.',
            icon: Icons.landscape_rounded,
            color: Colors.brown,
            progress: 0.0,
            categoryId: 'earthquake',
          ),
          const SizedBox(height: 32),
          const Text(
            'RESOURCES & GUIDES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            context,
            title: 'The Perfect Go-Bag',
            description: 'A comprehensive list of essentials for your emergency kit.',
            imageIcon: Icons.backpack_rounded,
            color: Colors.teal,
            resourceId: 'go-bag',
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            context,
            title: 'Family Communication Plan',
            description: 'How to stay in touch when service is down.',
            imageIcon: Icons.family_restroom_rounded,
            color: Colors.indigo,
            resourceId: 'family-plan',
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryRed, AppTheme.primaryRed.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
          SizedBox(height: 16),
          Text(
            'Be Ready for Anything',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Preparation is the best defense. Complete these checklists to ensure you and your family are safe.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double progress,
    required String categoryId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12)),
            if (progress > 0) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        onTap: () => context.pushNamed(
          AppRouteNames.checklist,
          pathParameters: {'categoryId': categoryId},
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData imageIcon,
    required Color color,
    required String resourceId,
  }) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRouteNames.resource,
        pathParameters: {'resourceId': resourceId},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(imageIcon, color: color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
