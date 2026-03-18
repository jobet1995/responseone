import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import '../config/themes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _timerFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    
    // Ensure we stay on splash for at least 3 seconds for brand exposure
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _timerFinished = true);
        _attemptRedirection();
      }
    });
  }

  void _attemptRedirection() {
    if (!_timerFinished) return;

    final userState = ref.read(currentUserProvider);
    if (!userState.isLoading) {
      _redirect(userState);
    }
  }

  void _redirect(AsyncValue<UserModel?> userState) {
    if (!mounted) return;
    
    userState.when(
      data: (user) => context.go(user != null ? '/home' : '/login'),
      loading: () {}, // Should not happen due to isLoading check
      error: (_, _) => context.go('/login'),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes to trigger redirection if the timer already finished
    ref.listen<AsyncValue<UserModel?>>(currentUserProvider, (previous, next) {
      if (_timerFinished && !next.isLoading) {
        _redirect(next);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              Text(
                'ResQNow',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'ALWAYS READY, ALWAYS THERE',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.5,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
              const SizedBox(
                width: 40,
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.backgroundLight,
                  color: AppTheme.primaryRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
