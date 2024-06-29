import 'dart:io';
import 'package:vania/vania.dart';
import 'create_user_table.dart';
import 'create_personal_access_tokens_table.dart';
import 'create_groups_table.dart';
import 'create_channels_table.dart';
import 'create_group_memberships_table.dart';
import 'create_channel_memberships_table.dart';
import 'create_messages_table.dart';
import 'create_conversations_table.dart';
import 'create_conversation_participants_table.dart';
import 'alter_foreign_key_conversation_to_message.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateUserTable().up();
    await CreatePersonalAccessTokensTable().up();
    await CreateGroupsTable().up();
    await CreateChannelsTable().up();
    await CreateGroupMembershipsTable().up();
    await CreateChannelMembershipsTable().up();
    await CreateMessagesTable().up();
    await CreateConversationsTable().up();
    await CreateConversationParticipantsTable().up();
    await AlterForeignKeyConversationToMessage().up();
  }

  dropTables() async {
    await CreateConversationParticipantsTable().down();
    await CreateConversationsTable().down();
    await CreateMessagesTable().down();
    await CreateChannelMembershipsTable().down();
    await CreateGroupMembershipsTable().down();
    await CreateChannelsTable().down();
    await CreateGroupsTable().down();
    await CreateUserTable().down();
  }
}
