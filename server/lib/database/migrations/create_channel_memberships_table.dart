import 'package:vania/vania.dart';

class CreateChannelMembershipsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('channel_memberships', () {
      id();
      bigInt('user_id', unsigned: true);
      bigInt('channel_id', unsigned: true);
      timeStamp('created_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('updated_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('deleted_at', nullable: true);

      foreign('user_id', 'users', 'id');
      foreign('channel_id', 'channels', 'id');
      index(
        ColumnIndex.indexKey,
        'idx_channel_memberships_channel_id',
        ['channel_id'],
      );
      index(
        ColumnIndex.indexKey,
        'idx_channel_memberships_user_id',
        ['user_id'],
      );
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('channel_memberships');
  }
}
