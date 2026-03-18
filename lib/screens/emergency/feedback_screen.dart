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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Responser'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How was the response?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your feedback helps us improve our emergency response network.',
              style: TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 48,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Add a comment (optional)...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'SUBMIT FEEDBACK',
              onPressed: _submitFeedback,
              isLoading: _isSubmitting,
            ),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Skip for now', style: TextStyle(color: AppTheme.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
