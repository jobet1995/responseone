import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

/// Provider for the [AuthService] instance.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

/// Notifier to manage the current user session and authentication state.
class UserNotifier extends Notifier<AsyncValue<UserModel?>> {
  @override
  AsyncValue<UserModel?> build() {
    _initialize();
    return const AsyncValue.loading();
  }

  AuthService get _authService => ref.read(authServiceProvider);

  /// Initial check for existing session on app startup.
  Future<void> _initialize() async {
    try {
      final user = await _authService.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Authenticates a user and updates the state.
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Registers a new user and updates the state.
  Future<void> register(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.register(data);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Logs out the user and clears the state.
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authService.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider to access the current user's data and state.
final currentUserProvider =
    NotifierProvider<UserNotifier, AsyncValue<UserModel?>>(UserNotifier.new);

/// Simple provider to check if the user is currently authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final userState = ref.watch(currentUserProvider);
  return userState.value != null;
});
