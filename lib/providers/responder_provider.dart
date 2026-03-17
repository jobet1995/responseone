import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responder_model.dart';
import '../models/user_model.dart';

/// Notifier to manage the responder-specific state (if the user is a responder).
class ResponderNotifier extends Notifier<AsyncValue<ResponderModel?>> {
  @override
  AsyncValue<ResponderModel?> build() {
    // Initial state is loading
    return const AsyncValue.loading();
  }

  /// Sets the responder data.
  void setResponder(ResponderModel? responder) {
    state = AsyncValue.data(responder);
  }

  /// Updates the responder's current availability status locally.
  void updateAvailability(bool isAvailable, ResponderStatus status) {
    state.whenData((responder) {
      if (responder != null) {
        state = AsyncValue.data(responder.copyWith(
          isAvailable: isAvailable,
          status: status,
        ));
      }
    });
  }

  /// Updates the current location locally.
  void updateLocation(LocationCoordinate location) {
    state.whenData((responder) {
      if (responder != null) {
        state = AsyncValue.data(responder.copyWith(currentLocation: location));
      }
    });
  }
}

/// Provider for responder data. 
final responderProvider =
    NotifierProvider<ResponderNotifier, AsyncValue<ResponderModel?>>(
  ResponderNotifier.new,
);

/// Provider to check if the current user is active as a responder.
final isActiveResponderProvider = Provider<bool>((ref) {
  final responderState = ref.watch(responderProvider);
  return responderState.value?.isAvailable ?? false;
});
