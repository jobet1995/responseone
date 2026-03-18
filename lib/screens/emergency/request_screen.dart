import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/emergency_model.dart';
import '../../providers/emergency_provider.dart';
import '../../widgets/custom_button.dart';
import '../../config/themes.dart';

class RequestScreen extends ConsumerStatefulWidget {
  final EmergencyType? initialType;

  const RequestScreen({super.key, this.initialType});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  final _descriptionController = TextEditingController();
  late EmergencyType _selectedType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType ?? EmergencyType.medical;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    
    final data = {
      'type': _selectedType.value,
      'description': _descriptionController.text,
      'status': EmergencyStatus.pending.value,
    };

    final result = await ref.read(emergencyHistoryProvider.notifier).reportEmergency(data);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (result) {
        Navigator.of(context).pop(); // Go back to home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emergency reported successfully! Help is on the way.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to report emergency. Please try again or call emergency services.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Emergency')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nature of Emergency',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.1),
            ),
            const SizedBox(height: 16),
            if (widget.initialType != null)
              _buildLockedTypeCard(widget.initialType!)
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: EmergencyType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(type.value),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedType = type),
                    selectedColor: AppTheme.primaryRed.withOpacity(0.1),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryRed : Colors.grey[300]!,
                      width: 1,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryRed : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 32),
            const Text(
              'Describe the situation (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'e.g., Someone fell unconscious, fire in the kitchen...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Responders will see your GPS location automatically.',
                      style: TextStyle(fontSize: 13, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'REQUEST IMMEDIATE HELP',
              onPressed: _handleSubmit,
              isLoading: _isSubmitting,
              backgroundColor: AppTheme.primaryRed,
              icon: Icons.emergency,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel Request', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedTypeCard(EmergencyType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryRed.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppTheme.primaryRed, size: 20),
          const SizedBox(width: 12),
          Text(
            type.value,
            style: const TextStyle(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
