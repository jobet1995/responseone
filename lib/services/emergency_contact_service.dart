import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/emergency_contact_model.dart';

class EmergencyContactService {
  final _supabase = Supabase.instance.client;

  EmergencyContactService._();
  static final EmergencyContactService instance = EmergencyContactService._();

  Future<List<EmergencyContactModel>> getContacts(String userId) async {
    try {
      final response = await _supabase
          .from('emergency_contacts')
          .select()
          .eq('user_id', userId)
          .order('created_at');

      final List data = response as List;
      return data.map((json) => EmergencyContactModel.fromMap(json)).toList();
    } catch (e) {
      print('Get Contacts Error: $e');
      return [];
    }
  }

  Future<bool> addContact(EmergencyContactModel contact) async {
    try {
      final data = contact.toMap();
      data.remove('id');
      await _supabase.from('emergency_contacts').insert(data);
      return true;
    } catch (e) {
      print('Add Contact Error: $e');
      return false;
    }
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      await _supabase.from('emergency_contacts').delete().eq('id', contactId);
      return true;
    } catch (e) {
      print('Delete Contact Error: $e');
      return false;
    }
  }
}
