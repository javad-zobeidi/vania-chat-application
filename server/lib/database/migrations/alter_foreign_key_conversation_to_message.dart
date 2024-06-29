import 'package:vania/vania.dart';

class AlterForeignKeyConversationToMessage extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await alterColumn('messages', () {
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
  }
}
