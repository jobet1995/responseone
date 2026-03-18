import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

/// Service to handle manual authentication (Login, Register, Logout) using Supabase Database.
/// Bypasses Supabase Auth service to avoid email rate limits.
class AuthService {
  SupabaseClient get _supabase => Supabase.instance.client;
  
  AuthService._();
  
  static final AuthService instance = AuthService._();

  static const String _userKey = 'user_data';
  static const String _sessionTokenKey = 'session_token';
  final _uuid = const Uuid();

  /// Hashes a password using SHA-256.
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Authenticates a user with username and password.
  Future<UserModel?> login(String username, String password) async {
    try {
      final hashedPassword = _hashPassword(password);

      // Directly query public.users table
      final userData = await _supabase
          .from('users')
          .select()
          .eq('username', username.toLowerCase().trim())
          .eq('password_hash', hashedPassword)
          .maybeSingle();

      if (userData != null) {
        final user = UserModel.fromMap(userData);
        
        // Save user and a fake session token to mimic logged-in state
        final prefs = await SharedPreferences.getInstance();
        await _saveUser(user);
        await prefs.setString(_sessionTokenKey, _uuid.v4());
        
        return user;
      } else {
        throw 'Invalid username or password';
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Registers a new user directly in the public.users table.
  Future<UserModel?> register(Map<String, dynamic> data) async {
    try {
      final username = data['username'] as String;
      final password = data['password'] as String;
      final name = data['name'] as String;
      final phoneNumber = data['phoneNumber'] as String;
      final role = data['role'] as String;
      final email = data['email'] as String;

      // Check if username already exists
      final existingUser = await _supabase
          .from('users')
          .select('id')
          .eq('username', username.toLowerCase().trim())
          .maybeSingle();
      
      if (existingUser != null) {
        throw 'Username already taken';
      }

      final userId = _uuid.v4();
      final hashedPassword = _hashPassword(password);
      
      // Create user profile in public.users table directly
      final userData = {
        'id': userId,
        'username': username.toLowerCase().trim(),
        'password_hash': hashedPassword,
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
      final prefs = await SharedPreferences.getInstance();
      await _saveUser(user);
      await prefs.setString(_sessionTokenKey, _uuid.v4());
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Logs out the user and clears manual local data.
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_sessionTokenKey);
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if a user is currently logged in.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_sessionTokenKey);
    return token != null;
  }

  /// Gets the currently logged in user.
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return UserModel.fromMap(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Uploads a profile picture to Supabase Storage.
  Future<String> uploadAvatar(XFile image) async {
    try {
      final String userId = (await getCurrentUser())?.id ?? _uuid.v4();
      final Uint8List bytes = await image.readAsBytes();
      final String fileExt = image.name.split('.').last;
      final String fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final String path = fileName;

      await _supabase.storage.from('avatars').uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String publicUrl = _supabase.storage.from('avatars').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      print('Error uploading avatar: $e');
      rethrow;
    }
  }

  /// Updates user data in the database and local storage.
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final data = user.toMap();
      // Remove sensitive or non-updatable fields if necessary
      data.remove('password_hash');
      
      await _supabase
          .from('users')
          .update(data)
          .eq('id', user.id);
      
      await _saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // --- Storage Helpers ---
  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toMap()));
  }
}
