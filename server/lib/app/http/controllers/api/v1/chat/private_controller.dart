import 'package:server/app/http/repositories/chat/private_chat_repository.dart';
import 'package:vania/vania.dart';

class PrivateController extends Controller {
  Future<Response> newMessage(Request request) async {
    request.merge({'user_id': Auth().id()});

    Map<String, dynamic> message = await PrivateChatRepository().newMessage(
      request.all(),
      request.file('media'),
    );

    return Response.json(message);
  }
}

final PrivateController privateController = PrivateController();
