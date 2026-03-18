import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

/// Service to handle authentication (Login, Register, Logout) using Supabase.
class AuthService {
  SupabaseClient get _supabase => Supabase.instance.client;
  
  AuthService._();
  
  static final AuthService instance = AuthService._();

  static const String _userKey = 'user_data';
  final _storage = const FlutterSecureStorage();

  /// Authenticates a user with email and password.
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Fetch user profile from public.users table
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();
        
        final user = UserModel.fromMap(userData);
        await _saveUser(user);
        
        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Registers a new user and creates a profile in the users table.
  Future<UserModel?> register(Map<String, dynamic> data) async {
    try {
      final email = data['email'] as String;
      final password = data['password'] as String;
      final name = data['name'] as String;
      final phoneNumber = data['phoneNumber'] as String;
      final role = data['role'] as String;

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id;
        
        // Create user profile in public.users table
        final userData = {
          'id': userId,
          'name': name,
          'email': email,
          'phone_number': phoneNumber,
          'role': role,
          'status': 'Active',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await _supabase.from('users').insert(userData);
        
        final user = UserModel.fromMap(userData);
        await _saveUser(user);
        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Logs out the user and clears local data.
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      await _storage.delete(key: _userKey);
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if a user is currently logged in.
  Future<bool> isLoggedIn() async {
    return _supabase.auth.currentSession != null;
  }

  /// Gets the currently logged in user.
  Future<UserModel?> getCurrentUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      try {
        return UserModel.fromMap(jsonDecode(userJson));
      } catch (e) {
        // Fallback to Supabase if local storage fails
      }
    }
    
    // If not in storage, try fetching from Supabase if session exists
    final session = _supabase.auth.currentSession;
    if (session != null) {
      try {
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', session.user.id)
            .single();
        final user = UserModel.fromMap(userData);
        await _saveUser(user);
        return user;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // --- Storage Helpers ---
  Future<void> _saveUser(UserModel user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toMap()));
  }
}
