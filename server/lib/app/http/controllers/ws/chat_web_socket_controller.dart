import 'package:vania/vania.dart';

class ChatWebSocketController extends Controller {
  Future newMessage(WebSocketClient client, dynamic message) async {}

  Future joinRoom(WebSocketClient client, dynamic payload) async {
    client.toRoom('message-to-room', payload['room'],
        payload['message']); // send the message to the room
  }
}

ChatWebSocketController chatController = ChatWebSocketController();
