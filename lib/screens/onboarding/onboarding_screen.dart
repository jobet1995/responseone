import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Real-time Emergency Response',
      description: 'Connect with professional responders and volunteers instantly when every second counts.',
      image: 'assets/images/onboarding_1.png', // Placeholder for now
      icon: Icons.speed_rounded,
    ),
    OnboardingData(
      title: 'Mental Health Support',
      description: 'Specialized assistance for psychological crises, ensuring delicate situations get the right care.',
      image: 'assets/images/onboarding_2.png',
      icon: Icons.psychology_rounded,
    ),
    OnboardingData(
      title: 'Safety Toolkit & Network',
      description: 'Built-in SOS tools and automatic alerts for your trusted contacts to keep you safe.',
      image: 'assets/images/onboarding_3.png',
      icon: Icons.security_rounded,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) => _buildPage(_pages[index]),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: const Text('SKIP', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildIndicator(index),
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  backgroundColor: AppTheme.primaryRed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 100, color: AppTheme.primaryRed),
          ),
          const SizedBox(height: 60),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppTheme.primaryRed : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });
}
