import 'package:vania/vania.dart';

class CreateGroupsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('groups', () {
      id();
      bigInt('owner_id', unsigned: true);
      string('group_name', length: 100);
      timeStamp('created_at',
          nullable: true, defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('updated_at',
          nullable: true, defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('deleted_at', nullable: true);

      foreign('owner_id', 'users', 'id');
      index(
        ColumnIndex.indexKey,
        'idx_groups_user_id',
        ['owner_id'],
      );
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('groups');
  }
}
