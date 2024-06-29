import 'package:faker/faker.dart';
import 'package:server/app/models/user.dart';
import 'package:vania/vania.dart';

class UserSeed extends Seeder {
  @override
  Future<void> run() async {
    try {
      final random = RandomGenerator(seed: 63833423);
      final faker = Faker.withGenerator(random);
      var counter = 0;

      do {
        await User().query().insert({
          "username": faker.internet.userName(),
          "email": faker.internet.email(),
          "password": Hash().make("123456"),
          "verified": 1
        });
        counter++;
      } while (counter < 15);
    } catch (e) {
      print(e.toString());
    }
  }
}
