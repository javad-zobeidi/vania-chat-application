import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    // createTableNotExists, This method will check if the user's table exists or not, If yes then it doesn't do anything
    // If you are using createTable, when you run migrate it will drop the table with all the data
    await createTableNotExists('users', () {
      id();
      string('username', length: 50);
      string('email', length: 50);
      string('password');
      string('avatar', nullable: true);
      smallInt('verified', length: 1, defaultValue: 0);
      timeStamp(
        'created_at',
        nullable: true,
        defaultValue: 'CURRENT_TIMESTAMP()',
      );
      timeStamp(
        'updated_at',
        nullable: true,
        defaultValue: 'CURRENT_TIMESTAMP()',
      );

      index(ColumnIndex.unique, 'username', ['username']);
      index(ColumnIndex.unique, 'email', ['email']);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
