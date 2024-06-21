import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    // createTableNotExists, This method will check if the user's table exists or not, If yes then it doesn't do anything
    // If you are using createTable, when you run migrate it will drop the table with all the data
    await createTableNotExists('users', () {
      id();
      tinyText('username');
      string('email', length: 50);
      string('password');
      string('avatar', nullable: true);
      smallInt('verified', length: 1, defaultValue: 0);
      timeStamps();

      index(ColumnIndex.unique, 'email', ['email']);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
