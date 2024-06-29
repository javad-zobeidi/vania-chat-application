import 'dart:io';
import 'package:vania/vania.dart';
import 'conversation_seed.dart';
import 'user_seed.dart';
import 'group_seed.dart';
import 'channel_seed.dart';

void main() async {
  Env().load();
  await DatabaseClient().setup();
  await DatabaseSeeder().registry();
  await DatabaseClient().database?.close();
  exit(0);
}

class DatabaseSeeder {
  registry() async {
    await UserSeed().run();
    await GroupSeed().run();
    await ChannelSeed().run();
    await ConversationSeed().run();
  }
}
