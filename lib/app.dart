import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/themes.dart';

/// The root widget of the ResQNow application.
/// Separated into a standalone widget to keep main.dart clean.
class ResQNowApp extends StatelessWidget {
  const ResQNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ResQNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
