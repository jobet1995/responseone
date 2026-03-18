import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../providers/first_aid_provider.dart';
import '../../models/first_aid_tip_model.dart';

class FirstAidScreen extends ConsumerWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsAsync = ref.watch(firstAidTipsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('First Aid Guide')),
      body: tipsAsync.when(
        data: (tips) {
          final categories = _groupTipsByCategory(tips);
          
          return ListView(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            children: categories.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildCategory(
                  context,
                  entry.key,
                  entry.value,
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Map<String, List<FirstAidTip>> _groupTipsByCategory(List<FirstAidTip> tips) {
    final Map<String, List<FirstAidTip>> map = {};
    for (var tip in tips) {
      if (!map.containsKey(tip.category)) {
        map[tip.category] = [];
      }
      map[tip.category]!.add(tip);
    }
    return map;
  }

  Widget _buildCategory(
    BuildContext context,
    String title,
    List<FirstAidTip> items,
  ) {
    // Determine icon and color based on title (or take from first item)
    final firstItem = items.first;
    final color = Color(firstItem.colorValue);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_getIconData(firstItem.iconName), color: color),
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
        ...items.map((tip) => _buildGuideItem(context, tip)).toList(),
      ],
    );
  }

  Widget _buildGuideItem(BuildContext context, FirstAidTip tip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tip.description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed(
          AppRouteNames.firstAidDetail,
          pathParameters: {'title': tip.id}, // Navigating by ID now
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'favorite': return Icons.favorite;
      case 'person_search': return Icons.person_search;
      case 'healing': return Icons.healing;
      case 'medical_services': return Icons.medical_services;
      default: return Icons.help_outline;
    }
  }
}
