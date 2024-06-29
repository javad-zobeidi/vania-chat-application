import 'dart:math';

import 'package:faker/faker.dart';
import 'package:server/app/models/group.dart';
import 'package:server/app/models/group_membership.dart';
import 'package:vania/vania.dart';

class GroupSeed extends Seeder {
  @override
  Future<void> run() async {
    try {
      final random = RandomGenerator(seed: 63833423);
      final faker = Faker.withGenerator(random);
      var counter = 1;
      List<int> users = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

      do {
        int id = await Group().query().insertGetId({
          "owner_id": counter,
          "group_name": faker.person.name(),
        });
        int user = users[Random().nextInt(users.length)];
        await GroupMembership().query().insert({
          "user_id": user,
          "group_id": id,
        });
        users.remove(user);
        user = Random().nextInt(users.length);
        await GroupMembership().query().insert({
          "user_id": user,
          "group_id": id,
        });
        users.remove(user);
        user = Random().nextInt(users.length);
        await GroupMembership().query().insert({
          "user_id": user,
          "group_id": id,
        });
        counter++;
      } while (counter <= 15);
    } catch (e) {
      print(e.toString());
    }
  }
}
