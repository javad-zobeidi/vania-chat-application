import 'package:vania/vania.dart';

class CreateChannelsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('channels', () {
      id();
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('channels');
  }
}
