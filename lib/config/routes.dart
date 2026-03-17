import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/emergency/request_screen.dart';
import '../screens/emergency/live_tracking_screen.dart';
import '../screens/emergency/first_aid_screen.dart';
import '../screens/responder/responder_dashboard.dart';
import '../screens/responder/responder_request_detail.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/assign_responder_screen.dart';
import '../screens/emergency/emergency_history_screen.dart';
import '../screens/home/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../models/emergency_model.dart';

/// Route constants for the ResQNow application.
class AppRouteNames {
  AppRouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String emergencyRequest = 'emergency_request';
  static const String emergencyTracking = 'emergency_tracking';
  static const String emergencyHistory = 'emergency_history';
  static const String firstAid = 'first_aid';
  static const String responderDashboard = 'responder_dashboard';
  static const String requestDetail = 'request_detail';
  static const String adminDashboard = 'admin_dashboard';
  static const String assignResponder = 'assign_responder';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String notifications = 'notifications';
}

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/login', // Start at login for now
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main Citizen Flow
      GoRoute(
        path: '/home',
        name: AppRouteNames.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'request',
            name: AppRouteNames.emergencyRequest,
            builder: (context, state) {
              final type = state.extra as EmergencyType?;
              return RequestScreen(initialType: type);
            },
          ),
          GoRoute(
            path: 'tracking/:emergencyId',
            name: AppRouteNames.emergencyTracking,
            builder: (context, state) {
              final id = state.pathParameters['emergencyId'] ?? '';
              return LiveTrackingScreen(emergencyId: id);
            },
          ),
          GoRoute(
            path: 'first-aid',
            name: AppRouteNames.firstAid,
            builder: (context, state) => const FirstAidScreen(),
          ),
          GoRoute(
            path: 'history',
            name: AppRouteNames.emergencyHistory,
            builder: (context, state) => const EmergencyHistoryScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: AppRouteNames.notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),

      // Responder Flow
      GoRoute(
        path: '/responder',
        name: AppRouteNames.responderDashboard,
        builder: (context, state) => const ResponderDashboard(),
        routes: [
          GoRoute(
            path: 'detail/:requestId',
            name: AppRouteNames.requestDetail,
            builder: (context, state) {
              final id = state.pathParameters['requestId'] ?? '';
              return ResponderRequestDetail(requestId: id);
            },
          ),
        ],
      ),

      // Admin Flow
      GoRoute(
        path: '/admin',
        name: AppRouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboard(),
        routes: [
          GoRoute(
            path: 'assign/:requestId',
            name: AppRouteNames.assignResponder,
            builder: (context, state) {
              final id = state.pathParameters['requestId'] ?? '';
              return AssignResponderScreen(requestId: id);
            },
          ),
        ],
      ),

      // System Routes (Minimal placeholders for real feel)
      GoRoute(
        path: '/profile',
        name: AppRouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Error: Page Not Found')),
    ),
  );
}
