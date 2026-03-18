import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/emergency_contact_model.dart';
import '../services/emergency_contact_service.dart';
import 'user_provider.dart';

class EmergencyContactsNotifier extends Notifier<AsyncValue<List<EmergencyContactModel>>> {
  @override
  AsyncValue<List<EmergencyContactModel>> build() {
    _fetchContacts();
    return const AsyncValue.loading();
  }

  Future<void> _fetchContacts() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      final contacts = await EmergencyContactService.instance.getContacts(user.id);
      state = AsyncValue.data(contacts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> addContact(EmergencyContactModel contact) async {
    try {
      final success = await EmergencyContactService.instance.addContact(contact);
      if (success) {
        await _fetchContacts();
        return true;
      }
    } catch (e) {
      print('Add Contact Error: $e');
    }
    return false;
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      final success = await EmergencyContactService.instance.deleteContact(contactId);
      if (success) {
        state.whenData((list) {
          state = AsyncValue.data(list.where((c) => c.id != contactId).toList());
        });
        return true;
      }
    } catch (e) {
      print('Delete Contact Error: $e');
    }
    return false;
  }
}

final emergencyContactsProvider = NotifierProvider<EmergencyContactsNotifier, AsyncValue<List<EmergencyContactModel>>>(EmergencyContactsNotifier.new);
