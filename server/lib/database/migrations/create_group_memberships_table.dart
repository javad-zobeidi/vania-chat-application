import 'package:vania/vania.dart';

class CreateGroupMembershipsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('group_memberships', () {
      id();
      bigInt('user_id', unsigned: true);
      bigInt('group_id', unsigned: true);
      timeStamp('created_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('updated_at', defaultValue: 'CURRENT_TIMESTAMP()');
      timeStamp('deleted_at', nullable: true);

      index(
        ColumnIndex.indexKey,
        'idx_group_memberships_group_id',
        ['group_id'],
      );
      index(
        ColumnIndex.indexKey,
        'idx_group_memberships_user_id',
        ['user_id'],
      );
      foreign('user_id', 'users', 'id');
      foreign('group_id', 'groups', 'id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('group_memberships');
  }
}
