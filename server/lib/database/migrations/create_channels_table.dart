import 'package:vania/vania.dart';

class CreateChannelsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('channels', () {
      id();
      bigInt('owner_id', unsigned: true);
      string('channel_name', length: 100);
      timeStamp('created_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('updated_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('deleted_at', nullable: true);

      foreign('owner_id', 'users', 'id');
      index(
        ColumnIndex.indexKey,
        'idx_channels_user_id',
        ['owner_id'],
      );
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('channels');
  }
}
