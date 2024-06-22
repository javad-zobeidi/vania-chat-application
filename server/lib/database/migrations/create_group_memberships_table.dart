import 'package:vania/vania.dart';

class CreateGroupMembershipsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('group_memberships', () {
      id();
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('group_memberships');
  }
}
