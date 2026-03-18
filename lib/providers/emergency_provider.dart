import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/emergency_service.dart';
import '../models/emergency_model.dart';
import 'user_provider.dart';

/// Provider for the [EmergencyService] instance.
final emergencyServiceProvider = Provider<EmergencyService>((ref) {
  return EmergencyService.instance;
});

/// Notifier to manage active and historical emergency reports.
class EmergencyNotifier extends Notifier<AsyncValue<List<EmergencyModel>>> {
  @override
  AsyncValue<List<EmergencyModel>> build() {
    final user = ref.watch(currentUserProvider).value;
    
    if (user != null) {
      // Small delay to avoid side-effects during build
      Future.microtask(() => fetchHistory());
    }
    
    return const AsyncValue.loading();
  }

  EmergencyService get _emergencyService => ref.read(emergencyServiceProvider);
  String? get _userId => ref.read(currentUserProvider).value?.id;

  /// Fetches the emergency history for the current user.
  Future<void> fetchHistory() async {
    final userId = _userId;
    if (userId == null) return;
    state = const AsyncValue.loading();
    try {
      final history = await _emergencyService.getEmergencyHistory(userId);
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Reports a new emergency and adds it to the current list.
  Future<bool> reportEmergency(Map<String, dynamic> data) async {
    final userId = _userId;
    if (userId == null) return false;

    try {
      final newEmergency = await _emergencyService.createEmergency({
        ...data,
        'citizen_id': userId,
      });
      
      if (newEmergency != null) {
        state.whenData((list) {
          state = AsyncValue.data([newEmergency, ...list]);
        });
        return true;
      }
    } catch (e) {
      print('EmergencyNotifier Error: $e');
    }
    return false;
  }

  /// Updates the status of an emergency in the local state.
  void updateLocalStatus(String id, EmergencyStatus status) {
    state.whenData((list) {
      final updatedList = list.map((e) {
        return e.id == id ? e.copyWith(status: status) : e;
      }).toList();
      state = AsyncValue.data(updatedList);
    });
  }
}

/// Provider to access the list of emergencies for the current user.
final emergencyHistoryProvider =
    NotifierProvider<EmergencyNotifier, AsyncValue<List<EmergencyModel>>>(
  EmergencyNotifier.new,
);
