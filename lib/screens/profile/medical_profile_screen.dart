import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/medical_profile_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/medical_profile_model.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class MedicalProfileScreen extends ConsumerStatefulWidget {
  const MedicalProfileScreen({super.key});

  @override
  ConsumerState<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends ConsumerState<MedicalProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bloodTypeController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicationsController;
  late TextEditingController _conditionsController;
  bool _isOrganDonor = false;
  bool _isInitialLoaded = false;

  @override
  void initState() {
    super.initState();
    _bloodTypeController = TextEditingController();
    _allergiesController = TextEditingController();
    _medicationsController = TextEditingController();
    _conditionsController = TextEditingController();
  }

  void _populateFields(MedicalProfileModel? profile) {
    if (profile != null && !_isInitialLoaded) {
      _bloodTypeController.text = profile.bloodType;
      _allergiesController.text = profile.allergies;
      _medicationsController.text = profile.medications;
      _conditionsController.text = profile.medicalConditions;
      _isOrganDonor = profile.organDonor;
      _isInitialLoaded = true;
    }
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final profile = MedicalProfileModel(
      id: '', // Service handles id/upsert
      userId: user.id,
      bloodType: _bloodTypeController.text,
      allergies: _allergiesController.text,
      medications: _medicationsController.text,
      medicalConditions: _conditionsController.text,
      organDonor: _isOrganDonor,
      updatedAt: DateTime.now(),
    );

    final success = await ref.read(medicalProfileProvider.notifier).updateProfile(profile);
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical profile updated successfully!')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update medical profile.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(medicalProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Medical Profile')),
      body: profileState.when(
        data: (profile) {
          _populateFields(profile);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Emergency Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This info will be visible to responders during an emergency.',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildSectionTitle('Basic Info'),
                  TextFormField(
                    controller: _bloodTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Blood Type',
                      hintText: 'e.g. O+, A-, etc.',
                      prefixIcon: Icon(Icons.bloodtype_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Health Details'),
                  TextFormField(
                    controller: _allergiesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Allergies',
                      hintText: 'List any allergies (food, medicine, etc.)',
                      prefixIcon: Icon(Icons.warning_amber_outlined),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _medicationsController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Current Medications',
                      hintText: 'List medications you are currently taking',
                      prefixIcon: Icon(Icons.medical_services_outlined),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _conditionsController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Medical Conditions',
                      hintText: 'e.g. Heart disease, Diabetes, Asthma...',
                      prefixIcon: Icon(Icons.info_outline),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Preferences'),
                  SwitchListTile(
                    title: const Text('Organ Donor'),
                    subtitle: const Text('Declare your status as an organ donor'),
                    value: _isOrganDonor,
                    onChanged: (v) => setState(() => _isOrganDonor = v),
                    activeColor: AppTheme.primaryRed,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 48),
                  CustomButton(
                    text: 'SAVE PROFILE',
                    onPressed: _handleSave,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryRed,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
