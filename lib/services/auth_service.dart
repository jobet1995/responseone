import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/user_model.dart';

/// Service to handle authentication (Login, Register, Logout).
class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  
  AuthService._() {
    // Add interceptors for token handling or logging here if needed
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }
  
  static final AuthService instance = AuthService._();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Authenticates a user with email and password.
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        final Map<String, dynamic> userData = response.data['user'];
        
        await _saveToken(token);
        final user = UserModel.fromMap(userData);
        await _saveUser(user);
        
        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Registers a new user.
  Future<UserModel?> register(Map<String, dynamic> registrationData) async {
    try {
      final response = await _dio.post('/auth/register', data: registrationData);

      if (response.statusCode == 201) {
        final String token = response.data['token'];
        final Map<String, dynamic> userData = response.data['user'];
        
        await _saveToken(token);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Checks if a user is currently logged in.
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  /// Gets the currently logged in user from local storage.
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

  // --- Storage Helpers ---
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toMap()));
  }
}
