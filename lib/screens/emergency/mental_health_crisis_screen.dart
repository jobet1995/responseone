import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/emergency_model.dart';
import '../../models/mental_health_model.dart';
import '../../providers/emergency_provider.dart';
import '../../widgets/custom_button.dart';
import '../../config/themes.dart';

class MentalHealthCrisisScreen extends ConsumerStatefulWidget {
  const MentalHealthCrisisScreen({super.key});

  @override
  ConsumerState<MentalHealthCrisisScreen> createState() => _MentalHealthCrisisScreenState();
}

class _MentalHealthCrisisScreenState extends ConsumerState<MentalHealthCrisisScreen> {
  final _descriptionController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _historyController = TextEditingController();
  
  MentalHealthCrisisType _selectedCrisisType = MentalHealthCrisisType.anxiety;
  RiskLevel _selectedRiskLevel = RiskLevel.medium;
  bool _isViolent = false;
  bool _hasWeapon = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _medicationsController.dispose();
    _historyController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    
    // In a real app, we would:
    // 1. Create the Emergency record first via emergencyHistoryProvider
    // 2. Then create the MentalHealthReport record linked to that emergency
    
    final emergencyData = {
      'type': EmergencyType.mentalHealth.value,
      'description': _descriptionController.text,
      'status': EmergencyStatus.pending.value,
    };

    final emergency = await ref.read(emergencyHistoryProvider.notifier).reportEmergency(emergencyData);

    if (mounted) {
      if (emergency != null) {
        // 2. Then create the MentalHealthReport record linked to that emergency
        final reportData = {
          'emergency_id': emergency.id,
          'crisis_type': _selectedCrisisType.value,
          'risk_level': _selectedRiskLevel.value,
          'is_violent': _isViolent,
          'has_weapon': _hasWeapon,
          'medications': _medicationsController.text,
          'history': _historyController.text,
        };

        final reportSuccess = await ref.read(emergencyServiceProvider).createMentalHealthReport(reportData);

        if (mounted) {
          setState(() => _isSubmitting = false);
          if (reportSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Crisis report submitted. A specialized responder is being dispatched.'),
                backgroundColor: Colors.purple,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Emergency reported, but failed to save detailed crisis info.')),
            );
          }
        }
      } else {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit report. Please call emergency services immediately.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Support'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('What are you experiencing?'),
            const SizedBox(height: 12),
            _buildCrisisTypeDropdown(),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Risk Assessment'),
            const SizedBox(height: 12),
            _buildRiskLevelSelector(),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Safety Check'),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Is there any violent behavior?'),
              value: _isViolent,
              onChanged: (val) => setState(() => _isViolent = val),
              activeColor: Colors.purple,
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: const Text('Are there any weapons involved?'),
              value: _hasWeapon,
              onChanged: (val) => setState(() => _hasWeapon = val),
              activeColor: Colors.purple,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Additional Information'),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Briefly describe the current situation...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _medicationsController,
              decoration: const InputDecoration(
                labelText: 'Known Medications (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 48),
            
            CustomButton(
              text: 'REQUEST SPECIALIZED HELP',
              onPressed: _handleSubmit,
              isLoading: _isSubmitting,
              backgroundColor: Colors.purple,
              icon: Icons.psychology,
            ),
            const SizedBox(height: 16),
            
            _buildHotlineCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
    );
  }

  Widget _buildCrisisTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MentalHealthCrisisType>(
          value: _selectedCrisisType,
          isExpanded: true,
          onChanged: (val) => setState(() => _selectedCrisisType = val!),
          items: MentalHealthCrisisType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRiskLevelSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: RiskLevel.values.map((level) {
        final isSelected = _selectedRiskLevel == level;
        return InkWell(
          onTap: () => setState(() => _selectedRiskLevel = level),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? Colors.purple : Colors.grey[300]!),
            ),
            child: Text(
              level.value,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHotlineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'Need someone to talk to right now?',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          const Text(
            'National Crisis Hotline: 988',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('CALL NOW'),
          ),
        ],
      ),
    );
  }
}
