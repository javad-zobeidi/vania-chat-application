import 'package:server/route/version/api_v1.dart';
import 'package:vania/vania.dart';
import 'package:server/route/web.dart';
import 'package:server/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    ApiV1().register();
    WebRoute().register();
    WebSocketRoute().register();
  }
}
