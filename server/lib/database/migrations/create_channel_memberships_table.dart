import 'package:vania/vania.dart';

class CreateChannelMembershipsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('channel_memberships', () {
      id();
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('channel_memberships');
  }
}
