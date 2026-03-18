import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/medical_profile_model.dart';

class MedicalProfileService {
  final _supabase = Supabase.instance.client;

  MedicalProfileService._();
  static final MedicalProfileService instance = MedicalProfileService._();

  Future<MedicalProfileModel?> getMedicalProfile(String userId) async {
    try {
      final response = await _supabase
          .from('medical_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return MedicalProfileModel.fromMap(response);
    } catch (e) {
      print('Get Medical Profile Error: $e');
      return null;
    }
  }

  Future<bool> updateMedicalProfile(MedicalProfileModel profile) async {
    try {
      final data = profile.toMap();
      data.remove('id'); // Let DB/Primary Key handle it if new, or eq(id) handle it if update
      
      await _supabase
          .from('medical_profiles')
          .upsert(data, onConflict: 'user_id');
      return true;
    } catch (e) {
      print('Update Medical Profile Error: $e');
      return false;
    }
  }
}
