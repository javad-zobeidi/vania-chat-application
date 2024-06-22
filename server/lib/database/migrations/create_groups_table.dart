import 'package:vania/vania.dart';

class CreateGroupsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('groups', () {
      id();
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('groups');
  }
}
