import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/emergency/request_screen.dart';
import '../screens/emergency/live_tracking_screen.dart';
import '../screens/emergency/first_aid_screen.dart';
import '../screens/emergency/first_aid_detail_screen.dart';
import '../screens/responder/responder_dashboard.dart';
import '../screens/responder/responder_request_detail.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/assign_responder_screen.dart';
import '../screens/emergency/emergency_history_screen.dart';
import '../screens/notifications/notification_center_screen.dart';
import '../screens/emergency/feedback_screen.dart';
import '../screens/emergency/chat_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/medical_profile_screen.dart';
import '../screens/profile/emergency_contacts_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/about_screen.dart';
import 'package:responseone/screens/main_screen.dart';
import 'package:responseone/screens/home/safety_map_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/emergency/mental_health_crisis_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/safety/safety_toolkit_screen.dart';
import '../screens/safety/preparedness_screen.dart';
import '../screens/safety/weather_alert_screen.dart';
import '../screens/safety/fake_call_screen.dart';
import '../screens/safety/in_call_screen.dart';
import '../screens/safety/share_location_screen.dart';
import '../models/emergency_model.dart';

/// Route constants for the ResQNow application.
class AppRouteNames {
  AppRouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String map = 'map';
  static const String emergencyRequest = 'emergency_request';
  static const String emergencyTracking = 'emergency_tracking';
  static const String emergencyHistory = 'emergency_history';
  static const String emergencyFeedback = 'emergency_feedback';
  static const String emergencyChat = 'emergency_chat';
  static const String firstAid = 'first_aid';
  static const String firstAidDetail = 'first_aid_detail';
  static const String responderDashboard = 'responder_dashboard';
  static const String requestDetail = 'request_detail';
  static const String adminDashboard = 'admin_dashboard';
  static const String assignResponder = 'assign_responder';
  static const String profile = 'profile';
  static const String editProfile = 'edit_profile';
  static const String mentalHealthRequest = 'mental_health_request';
  static const String onboarding = 'onboarding';
  static const String toolkit = 'toolkit';
  static const String preparedness = 'preparedness';
  static const String medicalProfile = 'medical_profile';
  static const String emergencyContacts = 'emergency_contacts';
  static const String settings = 'settings';
  static const String about = 'about';
  static const String notifications = 'notifications';
  static const String weatherAlert = 'weather_alert';
  static const String fakeCall = 'fake_call';
  static const String inCall = 'in_call';
  static const String shareLocation = 'share_location';
}

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/', // Start at splash
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
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

      // Main Shell Flow
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: AppRouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/map',
            name: AppRouteNames.map,
            builder: (context, state) => const SafetyMapScreen(),
          ),
          GoRoute(
            path: '/first-aid',
            name: AppRouteNames.firstAid,
            builder: (context, state) => const FirstAidScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: AppRouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/toolkit',
            name: AppRouteNames.toolkit,
            builder: (context, state) => const SafetyToolkitScreen(),
          ),
        ],
      ),

      // Other Citizen Screens (Full Screen)
      GoRoute(
        path: '/request',
        name: AppRouteNames.emergencyRequest,
        builder: (context, state) {
          final type = state.extra as EmergencyType?;
          if (type == EmergencyType.mentalHealth) {
            return const MentalHealthCrisisScreen();
          }
          return RequestScreen(initialType: type);
        },
      ),
      GoRoute(
        path: '/tracking/:emergencyId',
        name: AppRouteNames.emergencyTracking,
        builder: (context, state) {
          final id = state.pathParameters['emergencyId'] ?? '';
          return LiveTrackingScreen(emergencyId: id);
        },
      ),
      GoRoute(
        path: '/chat/:emergencyId',
        name: AppRouteNames.emergencyChat,
        builder: (context, state) {
          final id = state.pathParameters['emergencyId'] ?? '';
          return ChatScreen(emergencyId: id);
        },
      ),
      GoRoute(
        path: '/feedback/:emergencyId/:responderId',
        name: AppRouteNames.emergencyFeedback,
        builder: (context, state) {
          final id = state.pathParameters['emergencyId'] ?? '';
          final responderId = state.pathParameters['responderId'] ?? '';
          return FeedbackScreen(emergencyId: id, responderId: responderId);
        },
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/preparedness',
        name: AppRouteNames.preparedness,
        builder: (context, state) => const PreparednessScreen(),
      ),
      GoRoute(
        path: '/history',
        name: AppRouteNames.emergencyHistory,
        builder: (context, state) => const EmergencyHistoryScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: AppRouteNames.notifications,
        builder: (context, state) => const NotificationCenterScreen(),
      ),
      GoRoute(
        path: '/weather-alert',
        name: AppRouteNames.weatherAlert,
        builder: (context, state) => const WeatherAlertScreen(),
      ),
      GoRoute(
        path: '/fake-call',
        name: AppRouteNames.fakeCall,
        builder: (context, state) => const FakeCallScreen(),
      ),
      GoRoute(
        path: '/in-call',
        name: AppRouteNames.inCall,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return InCallScreen(
            name: data['name'] ?? 'Emergency Dispatch',
            number: data['number'] ?? '+1 (555) 0199',
          );
        },
      ),
      GoRoute(
        path: '/share-location',
        name: AppRouteNames.shareLocation,
        builder: (context, state) => const ShareLocationScreen(),
      ),
      GoRoute(
        path: '/first-aid/:title',
        name: AppRouteNames.firstAidDetail,
        builder: (context, state) {
          final title = state.pathParameters['title'] ?? '';
          return FirstAidDetailScreen(title: title);
        },
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

      // System Routes & Subroutes (Full Screen)
      GoRoute(
        path: '/profile/edit',
        name: AppRouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/medical',
        name: AppRouteNames.medicalProfile,
        builder: (context, state) => const MedicalProfileScreen(),
      ),
      GoRoute(
        path: '/profile/contacts',
        name: AppRouteNames.emergencyContacts,
        builder: (context, state) => const EmergencyContactsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'about',
            name: AppRouteNames.about,
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Error: Page Not Found')),
    ),
  );
}
