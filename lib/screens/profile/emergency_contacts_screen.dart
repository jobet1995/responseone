import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/emergency_contact_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/emergency_contact_model.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';

class EmergencyContactsScreen extends ConsumerStatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  ConsumerState<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends ConsumerState<EmergencyContactsScreen> {
  final _nameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAddContactDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Emergency Contact',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  prefixIcon: Icon(Icons.people_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'ADD CONTACT',
                onPressed: _handleAddContact,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddContact() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) return;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final contact = EmergencyContactModel(
      id: '',
      userId: user.id,
      name: _nameController.text,
      relationship: _relationshipController.text,
      phoneNumber: _phoneController.text,
      createdAt: DateTime.now(),
    );

    final success = await ref.read(emergencyContactsProvider.notifier).addContact(contact);
    
    if (mounted) {
      if (success) {
        Navigator.pop(context);
        _nameController.clear();
        _relationshipController.clear();
        _phoneController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact added successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsState = ref.watch(emergencyContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: contactsState.when(
        data: (contacts) {
          if (contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contact_phone_outlined, size: 80, color: Colors.grey.withOpacity(0.2)),
                  const SizedBox(height: 24),
                  const Text('No emergency contacts added yet.', style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'ADD CONTACT',
                    onPressed: _showAddContactDialog,
                    isFullWidth: false,
                    style: CustomButtonStyle.outlined,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryRed.withOpacity(0.1),
                    child: Text(contact.name[0].toUpperCase(), style: const TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${contact.relationship} • ${contact.phoneNumber}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => ref.read(emergencyContactsProvider.notifier).deleteContact(contact.id),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: AppTheme.primaryRed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
