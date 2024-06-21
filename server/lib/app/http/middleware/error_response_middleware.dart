import 'package:vania/vania.dart';

class ErrorResponseMiddleware extends Middleware {
  @override
  handle(Request req) async {
    print('This Is test');
    if (req.header('content-type') != 'application/json') {
      abort(400, 'Test');
    }
    return next?.handle(req);
  }
}
