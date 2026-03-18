import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_model.dart';

/// Service to handle real-time chat between citizens and responders.
class ChatService {
  final _supabase = Supabase.instance.client;

  ChatService._();
  
  static final ChatService instance = ChatService._();

  /// Sends a new message.
  Future<bool> sendMessage(MessageModel message) async {
    try {
      await _supabase.from('messages').insert(message.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns a stream of messages for a specific emergency.
  Stream<List<MessageModel>> getMessagesStream(String emergencyId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('emergency_id', emergencyId)
        .order('created_at')
        .map((data) => data.map((json) => MessageModel.fromMap(json)).toList());
  }
}
