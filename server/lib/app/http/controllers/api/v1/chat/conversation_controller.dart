import 'package:server/app/http/repositories/conversation/conversation_repository.dart';
import 'package:vania/vania.dart';

class ConversationController extends Controller {
  Future<Response> all() async {
    final conversations =
        await ConversationRepository().allConversations(Auth().id());
    return Response.json(conversations);
  }

  Future private() async => Response.json({});
  Future group() async => Response.json({});
  Future channel() async => Response.json({});
}

final ConversationController conversationController = ConversationController();
