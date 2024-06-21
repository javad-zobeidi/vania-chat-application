import 'package:vania/vania.dart';
import '../ddrt.dart';

class WebRoute implements Route {
  @override
  void register() {
    Router.get("/", () {
      final context = {
        'title': 'This is just a Vania Test',
        'isLoggedIn': true,
        'isGuest': false,
        'username': 'Javad',
        'users': [
          {
            'name': 'Vania',
            'email': 'info@vdart.dev',
            'roles': ['admin', 'user']
          },
          {
            'name': 'Javad',
            'email': 'javad@vdart.dev',
            'roles': ['user']
          },
        ],
        'userType': 'admin',
        'keepLooping': true
      };

      return view('index', context);
    });
  }
}
