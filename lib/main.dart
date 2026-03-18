import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/first_aid_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Load environment variables
    await dotenv.load(fileName: "assets/.env");
    
    // ... (rest of the logic)

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Missing required environment variables in .env');
    }

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    // Initialize notification service (now safe to access Supabase)
    await NotificationService.instance.initialize();
    
    // Initialize First Aid Service (Offline Cache)
    await FirstAidService.instance.init();
    
    runApp(
      const ProviderScope(
        child: ResQNowApp(),
      ),
    );
  } catch (e, stack) {
    debugPrint('Initialization error: $e');
    debugPrint(stack.toString());
    
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Initialization failed: $e\n\nPlease check your .env file and Supabase configuration.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
