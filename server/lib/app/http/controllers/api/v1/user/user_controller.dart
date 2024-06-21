import 'package:server/app/models/user.dart';
import 'package:vania/vania.dart';

class UserController extends Controller {
  Future<Response> index() async {
    Map? user = Auth().user();
    user?.remove('password');
    return Response.json(user);
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request) async {
    Map<String, dynamic> data = {};

    if (request.has('username')) {
      data['username'] = request.string('username');
    }

    if (request.has('email')) {
      data['email'] = request.string('email');
    }
    if (data.isNotEmpty) {
      await User().query().where('id', '=', Auth().id()).update(data);
    }

    return Response.json({'message': 'User updated successfully'});
  }

  Future<Response> updatePassword(Request request) async {
    request.validate({
      'current_password': 'required',
      'password': 'required|min_length:6|confirmed'
    }, {
      'current_password.required': 'Current password is required',
      'password.required': 'Password is required',
      'password.min_length': 'Password must be at least 6 characters',
      'password.confirmed': 'Password did not match',
    });

    String currentPassword = request.string('current_password');

    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      if (Hash().verify(currentPassword, user['password'])) {
        await User().query().where('id', '=', Auth().id()).update({
          'password': Hash().make(request.string('password')),
        });
        return Response.json({
          'status': 'success',
          'message': 'Password updated successfully',
        });
      } else {
        return Response.json({
          'status': 'error',
          'message': 'Current password does not match',
        }, 401);
      }
    } else {
      return Response.json({
        'status': 'error',
        'message': 'User not found',
      }, 404);
    }
  }

  Future<Response> updateAvatar(Request request) async {
    request.validate({
      'avatar': 'required|file:jpg,jpeg,png',
    }, {
      'avatar.required': 'Avatar file is required',
      'avatar.file': 'Avatar must be JPG or PNG',
    });

    RequestFile file = request.file('avatar') as RequestFile;

    String path = await file.move(
      path: publicPath('avatar/${Auth().id()}'),
      filename: file.filename,
    );

    if (path.startsWith(r'/')) {
      path = path.replaceFirst(r'/', '');
    }

    await User().query().where('id', '=', Auth().id()).update({
      'avatar': url(path),
    });
    return Response.json({
      'status': 'success',
      'message': 'Avatar updated successfully',
    });
  }

  Future<Response> destroy(int id) async {
    return Response.json({});
  }
}

final UserController userController = UserController();
