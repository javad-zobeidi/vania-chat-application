import 'package:server/app/http/repositories/auth/auth_repository.dart';
import 'package:vania/vania.dart';

class AuthController extends Controller {
  Future<Response> login(Request request) async {
    request.validate({
      'email': 'required|email',
      'password': 'required|min_length:6'
    }, {
      'email.required': 'Email is required',
      'email.email': 'Email is not valid',
      'password.required': 'Password is required',
      'password.min_length': 'Password must be at least 6 characters',
    });

    Map<String, dynamic> result = await AuthRepository().login(request.all());

    return Response.json(result, result['statusCode']);
  }

  Future<Response> signUp(Request request) async {
    // If you are using the confirmed rule for the password,
    // you must pass the password_confirmation key with your request too.
    request.validate({
      'username': 'required',
      'email': 'required|email',
      'password': 'required|min_length:6|confirmed'
    }, {
      'username.required': 'Username is required',
      'email.required': 'Email is required',
      'email.email': 'Email is not valid',
      'password.required': 'Password is required',
      'password.min_length': 'Password must be at least 6 characters',
      'password.confirmed': 'Password did not match',
    });

    // We send request fields except password_confirmation.
    Map<String, dynamic> result =
        await AuthRepository().signUp(request.except('password_confirmation'));

    return Response.json(result, result['statusCode']);
  }

  Future<Response> verifyOtp(Request request) async {
    request.validate({
      'email': 'required|email',
      'otp': 'required|min_length:6'
    }, {
      'otp.required': 'OTP is required',
      'otp.min_length': 'OTP must be 6 characters long',
      'email.required': 'Email is required',
      'email.email': 'Email is not valid',
    });

    Map<String, dynamic> result =
        await AuthRepository().verifyOtpCode(request.all());

    return Response.json(result, result['statusCode']);
  }


  Future<Response> refreshToken(Request request) async {
    String? refreshToken =
        request.header('authorization')?.replaceFirst('Bearer ', '');

    if (refreshToken == null) {
      return Response.json({'message': 'Invalid token'}, 401);
    }

    final token = await Auth()
        .createTokenByRefreshToken(refreshToken, expiresIn: Duration(days: 30));
    return Response.json(token, 201);
  }

}

final AuthController authController = AuthController();
