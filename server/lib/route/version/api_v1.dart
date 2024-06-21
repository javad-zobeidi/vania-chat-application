import 'package:server/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

import '../../app/http/controllers/api/v1/export_controllers.dart';

class ApiV1 extends Route {
  @override
  void register() {
    Router.basePrefix('api/v1/');

    // Authentication Routes
    Router.group(() {
      Router.post('login', authController.login);
      Router.post('sign-up', authController.signUp);
      Router.post('verify-otp', authController.verifyOtp);
      Router.post('refresh-token', authController.refreshToken);
    }, prefix: 'auth');

    Router.group(() {
      Router.get('', userController.index);
      Router.patch('password', userController.updatePassword);
      Router.patch('update', userController.update);
      Router.patch('avatar', userController.updateAvatar);
    }, prefix: '/user', middleware: [AuthenticateMiddleware()]);
  }
}
