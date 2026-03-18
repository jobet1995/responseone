import 'package:flutter/material.dart';
import '../../models/feedback_model.dart';
import '../../services/feedback_service.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  final String emergencyId;
  final String responderId;

  const FeedbackScreen({
    super.key,
    required this.emergencyId,
    required this.responderId,
  });

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      final feedback = FeedbackModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID logic
        emergencyId: widget.emergencyId,
        citizenId: user.id,
        responderId: widget.responderId,
        rating: _rating,
        comment: _commentController.text,
        createdAt: DateTime.now(),
      );

      final success = await FeedbackService.instance.submitFeedback(feedback);
      
      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!')),
          );
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit feedback. Please try again.')),
          );
        }
      }
    }
  }

  final List<String> _tags = [
    'Fast Response', 'Professional', 'Helpful', 'Knowledgeable', 'Safe', 'Clear Communication'
  ];
  final Set<String> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rating & Feedback'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildResponderInfo(),
            const SizedBox(height: 48),
            const Text(
              'How was your experience?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Your rating helps us maintain high quality\nservice in our emergency network.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildStarRating(),
            const SizedBox(height: 40),
            if (_rating > 0) ...[
              _buildTagsSection(),
              const SizedBox(height: 32),
            ],
            _buildCommentSection(),
            const SizedBox(height: 48),
            CustomButton(
              text: 'SUBMIT FEEDBACK',
              onPressed: _submitFeedback,
              isLoading: _isSubmitting,
            ),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Skip for now', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResponderInfo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primaryRed.withOpacity(0.1), width: 3),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.primaryRed.withOpacity(0.05),
            child: const Icon(Icons.person, size: 40, color: AppTheme.primaryRed),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Emergency Responder',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Incident ID: ${widget.emergencyId.substring(0, 8)}',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final bool isFilled = index < _rating;
        return GestureDetector(
          onTap: () => setState(() => _rating = index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 56,
              color: isFilled ? Colors.amber[600] : Colors.grey[300],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WHAT WENT WELL?',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) _selectedTags.add(tag);
                  else _selectedTags.remove(tag);
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primaryRed.withOpacity(0.1),
              checkmarkColor: AppTheme.primaryRed,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryRed : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? AppTheme.primaryRed : Colors.grey[300]!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COMMENTS',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _commentController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Share more about your experience...',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryRed),
            ),
          ),
        ),
      ],
    );
  }
}
