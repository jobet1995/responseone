import 'package:flutter/material.dart';
import '../../config/themes.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final String title;

  const FirstAidDetailScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for detail steps
    final List<String> steps = _getStepsForTitle(title);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium Instructional Header
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: Stack(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: const Icon(Icons.medical_information_outlined, size: 80, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Step-by-Step Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppTheme.primaryRed,
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            const Card(
              color: Color(0xFFFFF3E0), // Light orange
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Important: Always call professionals if you are unsure or if the situation worsens.',
                        style: TextStyle(color: Colors.brown, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // Logic to call emergency or go back
          },
          icon: const Icon(Icons.phone),
          label: const Text('CALL FOR HELP'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryRed,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }

  List<String> _getStepsForTitle(String title) {
    if (title == 'CPR') {
      return [
        'Check the scene for safety and the person for responsiveness.',
        'Call 911 or ask someone else to do it.',
        'Place the heel of one hand on the center of the chest.',
        'Place the other hand on top and interlock fingers.',
        'Push hard and fast: at least 2 inches deep and 100-120 beats per minute.',
        'Allow the chest to recoil completely between compressions.',
        'Continue until professional help arrives or an AED is available.',
      ];
    }
    return [
      'Assess the situation and ensure the area is safe.',
      'Calm the victim and explain what you are doing.',
      'Provide basic care based on the specific injury or condition.',
      'Monitor the victim\'s vital signs and level of consciousness.',
      'Stay with the victim until emergency responders take over.',
    ];
  }
}
