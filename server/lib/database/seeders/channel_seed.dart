import 'dart:math';

import 'package:faker/faker.dart';
import 'package:server/app/models/channel.dart';
import 'package:server/app/models/channel_membership.dart';
import 'package:vania/vania.dart';

class ChannelSeed extends Seeder {
  @override
  Future<void> run() async {
    final random = RandomGenerator(seed: 63833423);
    final faker = Faker.withGenerator(random);
    var counter = 1;
    List<int> users = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
    try {
      do {
        int id = await Channel().query().insertGetId({
          "owner_id": counter,
          "channel_name": faker.person.name(),
        });
        int user = users[Random().nextInt(users.length)];
        await ChannelMembership().query().insert({
          "user_id": user,
          "channel_id": id,
        });
        users.remove(user);
        user = Random().nextInt(users.length);
        await ChannelMembership().query().insert({
          "user_id": user,
          "channel_id": id,
        });
        users.remove(user);
        user = Random().nextInt(users.length);
        await ChannelMembership().query().insert({
          "user_id": user,
          "channel_id": id,
        });
        counter++;
      } while (counter <= 15);
    } catch (e) {
      print(e.toString());
    }
  }
}
