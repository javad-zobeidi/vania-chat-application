import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:server/app/http/helper/helper.dart';
import 'package:server/app/mail/verification_email.dart';
import 'package:server/app/models/user.dart';
import 'package:vania/vania.dart';

class AuthRepository {
  AuthRepository._internal();
  static final AuthRepository _singleton = AuthRepository._internal();
  factory AuthRepository() => _singleton;

  /// Login Method
  /// @param Map
  /// @return Map
  Future login(Map<String, dynamic> data) async {
    final Map<String, dynamic>? user =
        await User().query().where('email', '=', data['email']).first();

    if (user == null) {
      return {
        "status": "error",
        "message": "Email or password is incorrect.",
        "statusCode": HttpStatus.unauthorized,
      };
    }

    if (!Hash().verify(data['password'], user['password'])) {
      return {
        "status": "error",
        "message": "Email or password is incorrect.",
        "statusCode": HttpStatus.unauthorized,
      };
    }

    final token = await Auth().login(user).createToken(
          expiresIn: Duration(days: 30),
          withRefreshToken: true,
        );

    return {
      "status": "success",
      "token": token,
      "statusCode": HttpStatus.ok,
    };
  }

  /// Sign-up Method
  /// @param Map
  /// @return Map
  Future signUp(Map<String, dynamic> data) async {
    int otp = await genrateOtpCode(length: 6);
    final Map<String, dynamic>? isExists =
        await User().query().where('email', '=', data['email']).first();

    if (isExists != null) {
      return {
        "status": "error",
        "message": "Email already exists.",
        "statusCode": HttpStatus.conflict,
      };
    }

    // Store OTP in the cache
    await Cache.put(
      data['email'],
      otp.toString(),
      duration: Duration(minutes: 10), // Expires after 10 minutes
    );

    data['password'] = Hash().make(data['password']);

    // Store user data in the cache for 10 minutes. If the user can't verify their account within this time, the data will be removed from the cache to avoid storing incorrect and unused data in the database.
    await Cache.put(
      'user_${data['email']}',
      jsonEncode(data),
      duration: Duration(minutes: 10),
    );

    await VerificationEmail(
            to: data['email'], otp: otp, subject: 'OTP Verification')
        .send();

    return {
      "status": "success",
      "message": "The OTP has been sent.",
      "statusCode": HttpStatus.ok,
    };
  }

  /// Verify OTP Method
  /// @param Map
  /// @return Map
  Future verifyOtpCode(Map<String, dynamic> data) async {
    // First, get the OTP from the cache
    final otp = await Cache.get(data['email']);

    // Return error status code 400: Invalid OTP if the OTP is null and doesn't exist in the cache
    if (otp == null) {
      return {
        "status": "error",
        "message": "Invalid OTP.",
        "statusCode": HttpStatus.badRequest,
      };
    }

    // Return error status code 400: Invalid OTP if the cached OTP doesn't match the OTP sent by the client
    if (int.tryParse(otp.toString()) != int.tryParse(data['otp'].toString())) {
      return {
        "status": "error",
        "message": "Invalid OTP.",
        "statusCode": HttpStatus.badRequest,
      };
    }

    // Delete the cached OTP
    await Cache.delete(data['email']);

    // Get the cached data and store it in the database
    Map<String, dynamic> userData =
        jsonDecode(await Cache.get('user_${data['email']}'));

    // Add date and verified status to the user data map to store in the database
    userData['created_at'] = DateTime.now().toUtc();
    userData['updated_at'] = DateTime.now().toUtc();
    userData['verified'] = 1;

    final userId = await User().query().insertGetId(userData);
    data['id'] = userId;
    data['username'] = userData['username'];

    data.remove('password');
    data.remove('otp');

    await Cache.delete('user_${data['email']}');

    final token = await Auth().login(data).createToken(
          expiresIn: Duration(days: 30),
          withRefreshToken: true,
        );

    return {
      "status": "success",
      "message": "User created.",
      "token": token,
      "statusCode": HttpStatus.created,
    };
  }
}
