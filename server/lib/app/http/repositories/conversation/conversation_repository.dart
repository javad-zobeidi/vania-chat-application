import 'package:server/app/models/conversation.dart';
import 'package:vania/vania.dart';

class ConversationRepository {
  ConversationRepository._internal();
  static final ConversationRepository _singleton =
      ConversationRepository._internal();
  factory ConversationRepository() => _singleton;

// This method returns all user conversations including Private chats, Group chats, and Channels
  Future<List<Map<String, dynamic>>> allConversations(int userId) async {
    return await Conversation()
        .query()
        .selectRaw('''conversations.id AS conversation_id, 
        CASE 
        WHEN conversations.type = "private" THEN "private" 
        WHEN conversations.type = "group" THEN "group" 
        WHEN conversations.type = "channel" THEN "channel" 
        END AS conversation_type, 
        g.group_name, 
        ch.channel_name, 
        m.content AS last_message_content, 
        m.created_at AS last_message_time''')
        .leftJoin('messages as m', 'conversations.last_message_id', '=', 'm.id')
        .leftJoin('conversation_participants as cp', 'conversations.id', '=',
            'cp.conversation_id')
        .leftJoin('groups as g', 'cp.group_id', '=', 'g.id')
        .leftJoin('group_memberships as gm', 'g.id', '=', 'gm.group_id')
        .leftJoin('channels as ch', 'cp.channel_id', '=', 'ch.id')
        .leftJoin('channel_memberships as cm', 'ch.id', '=', 'cm.channel_id')
        .where((QueryBuilder q) {
          q
              .where('cp.user_id', '=', userId)
              .where('conversations.type', '=', 'private')
              .orWhere((QueryBuilder q2) {
            q2
                .whereNotNull('gm.user_id')
                .where('gm.user_id', '=', userId)
                .where('conversations.type', '=', 'group');
          }).orWhere((QueryBuilder q3) {
            q3
                .whereNotNull('cm.user_id')
                .where('cm.user_id', '=', userId)
                .where('conversations.type', '=', 'channel');
          });
        })
        .orderBy('m.created_at', 'desc')
        .get();
  }
}
