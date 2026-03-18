import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/feedback_model.dart';

/// Service to handle responder feedback using Supabase.
class FeedbackService {
  final _supabase = Supabase.instance.client;

  FeedbackService._();
  
  static final FeedbackService instance = FeedbackService._();

  /// Submits a new feedback entry.
  Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      await _supabase.from('feedback').insert(feedback.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Fetches feedback for a specific responder.
  Future<List<FeedbackModel>> getFeedbackForResponder(String responderId) async {
    try {
      final response = await _supabase
          .from('feedback')
          .select()
          .eq('responder_id', responderId)
          .order('created_at', ascending: false);

      final List data = response as List;
      return data.map((json) => FeedbackModel.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
