import 'dart:io';
import 'package:vania/vania.dart';
import 'create_user_table.dart';
import 'create_personal_access_tokens_table.dart';
import 'create_groups_table.dart';
import 'create_channels_table.dart';
import 'create_group_memberships_table.dart';
import 'create_channel_memberships_table.dart';

void main() async {
  await Migrate().registry();
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await MigrationConnection().setup();
    await CreateUserTable().up();
    await CreatePersonalAccessTokensTable().up();
    await CreateGroupsTable().up();
    await CreateChannelsTable().up();
    await CreateGroupMembershipsTable().up();
    await CreateChannelMembershipsTable().up();
  }
}

dropTables() async {
  await CreateChannelMembershipsTable().down();
  await CreateGroupMembershipsTable().down();
  await CreateChannelsTable().down();
  await CreateGroupsTable().down();
}
