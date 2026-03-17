import 'package:flutter/material.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  // Mock contacts for now
  final List<Map<String, String>> _contacts = [
    {'name': 'Maria Dela Cruz', 'relation': 'Mother', 'phone': '0917 123 4567'},
    {'name': 'Juan Dela Cruz', 'relation': 'Brother', 'phone': '0918 987 6543'},
  ];

  void _addContact() {
    // Show dialog to add contact
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            color: AppTheme.primaryRed.withValues(alpha: 0.05),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.primaryRed),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'These contacts will be notified automatically when you trigger an SOS alert.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _contacts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.defaultPadding),
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      final contact = _contacts[index];
                      return _buildContactCard(contact);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            child: CustomButton(
              text: 'ADD NEW CONTACT',
              onPressed: _addContact,
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contact_phone_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('No emergency contacts added yet.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, String> contact) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryRed.withValues(alpha: 0.1),
          child: Text(
            contact['name']![0],
            style: const TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${contact['relation']} • ${contact['phone']}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {},
        ),
      ),
    );
  }
}
