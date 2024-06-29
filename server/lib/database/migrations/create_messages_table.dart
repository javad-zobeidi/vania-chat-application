import 'package:vania/vania.dart';

class CreateMessagesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('messages', () {
      id();
      bigInt('conversation_id', unsigned: true);
      bigInt('sender_id', unsigned: true);
      text('content');
      string('media', nullable: true);
      enumType(
          'type',
          [
            'text',
            'image',
            'doc',
            'video',
            'audio',
            'notification',
          ],
          defaultValue: 'text');
      timeStamp('created_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('updated_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('deleted_at', nullable: true);

      index(
        ColumnIndex.indexKey,
        'idx_messages_conversation_id',
        ['conversation_id'],
      );
      foreign(
        'sender_id',
        'users',
        'id',
        onDelete: 'CASCADE',
      );
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('messages');
  }
}
