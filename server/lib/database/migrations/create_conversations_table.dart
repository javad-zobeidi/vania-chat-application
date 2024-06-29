import 'package:vania/vania.dart';

class CreateConversationsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('conversations', () {
      id();
      enumType('type', ['private', 'group', 'channel'],
          defaultValue: 'private');
      bigInt('last_message_id', unsigned: true, nullable: true);
      timeStamp('created_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('updated_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('deleted_at', nullable: true);

      index(
        ColumnIndex.indexKey,
        'idx_conversations_message_id',
        ['last_message_id'],
      );
      foreign('last_message_id', 'messages', 'id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('conversations');
  }
}
