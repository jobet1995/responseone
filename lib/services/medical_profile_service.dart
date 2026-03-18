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

  Future<MedicalProfileModel?> updateMedicalProfile(MedicalProfileModel profile) async {
    try {
      final data = profile.toMap();
      if (profile.id.isEmpty) {
        data.remove('id');
      }
      
      final response = await _supabase
          .from('medical_profiles')
          .upsert(data, onConflict: 'user_id')
          .select()
          .single();
          
      return MedicalProfileModel.fromMap(response);
    } catch (e) {
      // ignore: avoid_print
      print('Update Medical Profile Error: $e');
      return null;
    }
  }
}
