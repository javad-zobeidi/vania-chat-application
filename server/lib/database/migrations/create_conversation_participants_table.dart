import 'package:vania/vania.dart';

class CreateConversationParticipantsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('conversation_participants', () {
      bigInt('user_id', unsigned: true, nullable: true);
      bigInt('group_id', unsigned: true, nullable: true);
      bigInt('channel_id', unsigned: true, nullable: true);
      bigInt('conversation_id', unsigned: true);

      index(
        ColumnIndex.indexKey,
        'idx_conversation_participants_user_id',
        ['user_id'],
      );
      index(
        ColumnIndex.indexKey,
        'idx_conversation_participants_group_id',
        ['group_id'],
      );
      index(
        ColumnIndex.indexKey,
        'idx_conversation_participants_channel_id',
        ['channel_id'],
      );
      foreign(
        'user_id',
        'users',
        'id',
        onDelete: 'CASCADE',
      );
      foreign(
        'group_id',
        'groups',
        'id',
        onDelete: 'CASCADE',
      );
      foreign(
        'channel_id',
        'channels',
        'id',
        onDelete: 'CASCADE',
      );
      foreign(
        'conversation_id',
        'conversations',
        'id',
        onDelete: 'CASCADE',
      );
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('conversation_participants');
  }
}
