import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medical_profile_model.dart';
import '../services/medical_profile_service.dart';
import 'user_provider.dart';

class MedicalProfileNotifier extends Notifier<AsyncValue<MedicalProfileModel?>> {
  @override
  AsyncValue<MedicalProfileModel?> build() {
    _fetchProfile();
    return const AsyncValue.loading();
  }

  Future<void> _fetchProfile() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final profile = await MedicalProfileService.instance.getMedicalProfile(user.id);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateProfile(MedicalProfileModel profile) async {
    try {
      final success = await MedicalProfileService.instance.updateMedicalProfile(profile);
      if (success) {
        state = AsyncValue.data(profile);
        return true;
      }
    } catch (e) {
      print('Update Profile Error: $e');
    }
    return false;
  }
}

final medicalProfileProvider = NotifierProvider<MedicalProfileNotifier, AsyncValue<MedicalProfileModel?>>(MedicalProfileNotifier.new);
