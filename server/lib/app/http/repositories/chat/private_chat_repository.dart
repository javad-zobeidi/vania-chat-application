import 'package:server/app/models/conversation.dart';
import 'package:server/app/models/conversation_participant.dart';
import 'package:server/app/models/message.dart';
import 'package:vania/vania.dart';

class PrivateChatRepository {
  PrivateChatRepository._internal();
  static final PrivateChatRepository _singleton =
      PrivateChatRepository._internal();
  factory PrivateChatRepository() => _singleton;

  Future<Map<String, dynamic>> newMessage(
    Map<String, dynamic> data, [
    RequestFile? media,
  ]) async {
    final receiverId = data['receiver'];
    final userId = data['user_id'];
    final type = data['type'];

    // Will create a new conversation if it does not exist between these two users  or return the active conversation ID
    data['conversation_id'] = await _createNewConversation(
      userId,
      receiverId,
    );

    // Create new chat message
    Map<String, dynamic> message = await _storeMessage(data);

    await _updateConversation(data['conversation_id'], message['id']);

    if (type != 'text') {
      if (media != null) {
        String path = await _uploadMedia(media, type, userId, message['id']);
        message['media'] = path;
      }
    }

    return message;
  }

// Return Active conversatyion Or Null
  Future<Map<String, dynamic>?> _getActiveConversation(
    int userId,
    int receiverId,
  ) async {
    return await Conversation()
        .query()
        .select(['conversations.id'])
        .join('conversation_participants as cp1', 'conversations.id', '=',
            'cp1.conversation_id')
        .join('conversation_participants as cp2', 'conversations.id', '=',
            'cp2.conversation_id')
        .where('conversations.type', '=', 'private')
        .where('cp1.user_id', '=', userId)
        .where('cp2.user_id', '=', receiverId)
        .where('cp1.user_id', '<>', 'cp2.user_id')
        .first();
  }

  // Create New Conversationn or return Active Conversation ID
  Future<int> _createNewConversation(
    int userId,
    int receiverId,
  ) async {
    // Will return the active conversation between these two users or null
    final conversation = await _getActiveConversation(
      userId,
      receiverId,
    );

    if (conversation == null) {
      final conversationId = await Conversation().query().insertGetId({
        "type": "private",
      });

      await ConversationParticipant().query().insertMany([
        {
          "user_id": userId,
          "conversation_id": conversationId,
        },
        {
          "user_id": receiverId,
          "conversation_id": conversationId,
        }
      ]);
      return conversationId;
    } else {
      return conversation['id'];
    }
  }

  // Store message
  Future<Map<String, dynamic>> _storeMessage(Map<String, dynamic> data) async {
    return await Message().query().create({
      "conversation_id": data['conversation_id'],
      "sender_id": data['user_id'],
      "content": data['content'],
      "type": data['type'],
    });
  }

  // Add last message id to the conversation
  Future<void> _updateConversation(int conversationId, int messageId) async {
    await Conversation().query().where('id', '=', conversationId).update({
      "last_message_id": messageId,
    });
  }

  // Upload media file
  Future<String> _uploadMedia(
    RequestFile file,
    type,
    userId,
    messageId,
  ) async {
    String path = await file.move(
      path: 'public/user/media/$type/$userId',
      filename: file.filename,
    );

    await Message().query().where('id', '=', messageId).update({
      'media': path,
    });
    return path;
  }
}
