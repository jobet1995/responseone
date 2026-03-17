import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Route constants for the ResQNow application.
/// Using a dedicated class for route names avoids hardcoded strings
/// and makes refactoring easier.
class AppRouteNames {
  AppRouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String emergencyRequest = 'emergency_request';
  static const String emergencyTracking = 'emergency_tracking';
  static const String emergencyHistory = 'emergency_history';
  static const String responderDashboard = 'responder_dashboard';
  static const String requestDetail = 'request_detail';
  static const String adminDashboard = 'admin_dashboard';
  static const String assignResponder = 'assign_responder';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String notifications = 'notifications';
  static const String onboarding = 'onboarding';
}

/// Central routing configuration for ResQNow.
/// This uses the `go_router` package for robust, parameter-aware navigation.
class AppRouter {
  AppRouter._();

  // Root Navigator Key for global access if needed (e.g., showing dialogs)
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: AppRouteNames.splash,
        builder: (context, state) => const _PlaceholderScreen(title: 'Splash Screen'),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (context, state) => const _PlaceholderScreen(title: 'Login Screen'),
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const _PlaceholderScreen(title: 'Register Screen'),
      ),

      // Main Citizen Flow
      GoRoute(
        path: '/home',
        name: AppRouteNames.home,
        builder: (context, state) => const _PlaceholderScreen(title: 'Home Screen'),
        routes: [
          GoRoute(
            path: 'request',
            name: AppRouteNames.emergencyRequest,
            builder: (context, state) => const _PlaceholderScreen(title: 'Emergency Request'),
          ),
          GoRoute(
            path: 'tracking/:emergencyId',
            name: AppRouteNames.emergencyTracking,
            builder: (context, state) {
              final id = state.pathParameters['emergencyId'] ?? '';
              return _PlaceholderScreen(title: 'Tracking Emergency: $id');
            },
          ),
          GoRoute(
            path: 'history',
            name: AppRouteNames.emergencyHistory,
            builder: (context, state) => const _PlaceholderScreen(title: 'Emergency History'),
          ),
        ],
      ),

      // Responder Flow
      GoRoute(
        path: '/responder',
        name: AppRouteNames.responderDashboard,
        builder: (context, state) => const _PlaceholderScreen(title: 'Responder Dashboard'),
        routes: [
          GoRoute(
            path: 'detail/:requestId',
            name: AppRouteNames.requestDetail,
            builder: (context, state) {
              final id = state.pathParameters['requestId'] ?? '';
              return _PlaceholderScreen(title: 'Request Details: $id');
            },
          ),
        ],
      ),

      // Admin Flow
      GoRoute(
        path: '/admin',
        name: AppRouteNames.adminDashboard,
        builder: (context, state) => const _PlaceholderScreen(title: 'Admin Dashboard'),
        routes: [
          GoRoute(
            path: 'assign/:requestId',
            name: AppRouteNames.assignResponder,
            builder: (context, state) {
              final id = state.pathParameters['requestId'] ?? '';
              return _PlaceholderScreen(title: 'Assign Responder to: $id');
            },
          ),
        ],
      ),

      // User & System Routes
      GoRoute(
        path: '/profile',
        name: AppRouteNames.profile,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: '/settings',
        name: AppRouteNames.settings,
        builder: (context, state) => const _PlaceholderScreen(title: 'Settings'),
      ),
      GoRoute(
        path: '/notifications',
        name: AppRouteNames.notifications,
        builder: (context, state) => const _PlaceholderScreen(title: 'Notifications'),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRouteNames.onboarding,
        builder: (context, state) => const _PlaceholderScreen(title: 'Onboarding'),
      ),
    ],
    
    // Global redirects or error handling could be added here
    errorBuilder: (context, state) => const _PlaceholderScreen(title: 'Error: Page Not Found'),
  );
}

/// Navigation extension for cleaner context-based navigation calls.
/// Use like: context.pushTo(AppRouteNames.home)
extension AppNavigation on BuildContext {
  void pushTo(String name, {Map<String, String> params = const {}, Object? extra}) {
    pushNamed(name, pathParameters: params, extra: extra);
  }

  void goTO(String name, {Map<String, String> params = const {}, Object? extra}) {
    goNamed(name, pathParameters: params, extra: extra);
  }

  void replaceWith(String name, {Map<String, String> params = const {}, Object? extra}) {
    pushReplacementNamed(name, pathParameters: params, extra: extra);
  }

  void clearStackAndGo(String name) {
    while (canPop()) {
      pop();
    }
    goNamed(name);
  }
}

/// Private placeholder to demonstrate builder connection without actual UI code.
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text(title)));
}
