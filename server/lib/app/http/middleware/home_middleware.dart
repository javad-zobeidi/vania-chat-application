import 'package:vania/vania.dart';

class HomeMiddleware extends Middleware {
  @override
  handle(Request req) async {
    print('Test From Home');
    //abort(400, "Test Error");
    return next?.handle(req);
  }
}
