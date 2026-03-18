import 'package:flutter/material.dart';
import '../../config/themes.dart';

class ResourceDetailScreen extends StatelessWidget {
  final String resourceId;

  const ResourceDetailScreen({
    super.key,
    required this.resourceId,
  });

  @override
  Widget build(BuildContext context) {
    // Content definitions for resources
    final resources = {
      'go-bag': {
        'title': 'The Perfect Go-Bag',
        'subtitle': 'Everything you need to survive for 72 hours.',
        'color': Colors.teal,
        'icon': Icons.backpack_rounded,
        'sections': [
          {
            'title': 'Survival Essentials',
            'items': [
              'Water: 1 liter per person per day (3-day supply minimum).',
              'Food: Non-perishable, high-energy items (energy bars, canned goods).',
              'Flashlight: With extra batteries or hand-crank capability.',
              'First Aid Kit: Comprehensive kit with bandages, antiseptic, and personal medications.',
            ],
          },
          {
            'title': 'Communication & Navigation',
            'items': [
              'Radio: Battery-powered or hand-crank NOAA Weather Radio.',
              'Backup Power: Portable power bank with charging cables.',
              'Whistle: To signal for help if trapped or lost.',
              'Maps: Local area maps (paper version as backup to GPS).',
            ],
          },
          {
            'title': 'Personal & Legal',
            'items': [
              'Documents: Sealed copies of ID, insurance policies, and medical records.',
              'Cash: Small bills and change (ATMs may not work during outages).',
              'Multi-tool: Versatile tool for repairs or food preparation.',
              'Sanitation: Moist towelettes, garbage bags, and plastic ties.',
            ],
          },
        ],
      },
      'family-plan': {
        'title': 'Family Communication Plan',
        'subtitle': 'Ensuring everyone knows what to do and where to go.',
        'color': Colors.indigo,
        'icon': Icons.family_restroom_rounded,
        'sections': [
          {
            'title': 'Contact Information',
            'items': [
              'Emergency Contacts: List of immediate family, neighbors, and doctors.',
              'Out-of-Town Contact: A designated relative who lives far away to coordinate info.',
              'Text First: Text messages often go through when calls fail during disasters.',
            ],
          },
          {
            'title': 'Meeting Places',
            'items': [
              'Immediate Area: A spot right outside your home (e.g., a specific tree or mailbox).',
              'Local Neighborhood: A place like a library or community center if you can\'t reach home.',
              'Out-of-Area: A regional location if you are separated and cannot return home.',
            ],
          },
          {
            'title': 'Plan & Practice',
            'items': [
              'School/Work Info: Detailed info on locations and evacuation protocols for everyone.',
              'Regular Drills: Practice your plan every 6 months with the whole family.',
              'Physical Copies: Keep a printed version of your plan in every family member\'s bag.',
            ],
          },
        ],
      },
    };

    final resource = resources[resourceId] ?? resources['go-bag']!;
    final Color primaryColor = resource['color'] as Color;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                resource['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    resource['icon'] as IconData,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['subtitle'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...(resource['sections'] as List).map((section) {
                    return _buildSection(
                      context,
                      section['title'] as String,
                      section['items'] as List<String>,
                      primaryColor,
                    );
                  }).toList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) {
          final parts = item.split(': ');
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_rounded, color: color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: parts.length > 1
                      ? RichText(
                          text: TextSpan(
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.4),
                            children: [
                              TextSpan(
                                text: '${parts[0]}: ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: parts[1]),
                            ],
                          ),
                        )
                      : Text(
                          item,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.4),
                        ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 24),
      ],
    );
  }
}
