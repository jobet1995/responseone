import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/emergency_model.dart';

/// Service to handle emergency reports and interactions using Supabase.
class EmergencyService {
  SupabaseClient get _supabase => Supabase.instance.client;

  EmergencyService._();
  
  static final EmergencyService instance = EmergencyService._();

  /// Reports a new emergency.
  Future<EmergencyModel?> createEmergency(Map<String, dynamic> emergencyData) async {
    try {
      // Ensure basic structure matches DB schema perfectly
      final insertData = {
        'citizen_id': emergencyData['citizen_id'],
        'type': emergencyData['type'],
        'status': emergencyData['status'] ?? 'Pending',
        'description': emergencyData['description'] ?? '',
        'location': emergencyData['location'] ?? {'latitude': 0.0, 'longitude': 0.0},
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('emergencies')
          .insert(insertData)
          .select()
          .single();

      return EmergencyModel.fromMap(response);
    } catch (e) {
      print('Emergency Insert Error: $e');
      rethrow;
    }
  }

  /// Fetches a specific emergency by ID.
  Future<EmergencyModel?> getEmergencyById(String id) async {
    try {
      final response = await _supabase
          .from('emergencies')
          .select()
          .eq('id', id)
          .single();
      
      return EmergencyModel.fromMap(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the status of an emergency (e.g., Assigned, Arrived).
  Future<bool> updateEmergencyStatus(String id, String status) async {
    try {
      await _supabase.from('emergencies').update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Fetches all emergencies reported by a specific user.
  Future<List<EmergencyModel>> getEmergencyHistory(String citizenId) async {
    try {
      final response = await _supabase
          .from('emergencies')
          .select()
          .eq('citizen_id', citizenId)
          .order('created_at', ascending: false);

      final List data = response as List;
      return data.map((json) => EmergencyModel.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Creates a detailed mental health crisis report linked to an emergency.
  Future<bool> createMentalHealthReport(Map<String, dynamic> reportData) async {
    try {
      await _supabase.from('mental_health_reports').insert({
        'emergency_id': reportData['emergency_id'],
        'crisis_type': reportData['crisis_type'],
        'risk_level': reportData['risk_level'],
        'is_violent': reportData['is_violent'] ?? false,
        'has_weapon': reportData['has_weapon'] ?? false,
        'medications': reportData['medications'] ?? '',
        'history': reportData['history'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Mental Health Report Insert Error: $e');
      return false;
    }
  }
}
