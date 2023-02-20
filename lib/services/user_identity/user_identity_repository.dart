import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:basic_utils/basic_utils.dart';

import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/services/notification/notification_repository.dart';
import 'package:iclavis/services/property/property_repository.dart';
import 'package:iclavis/services/user_storage/user_storage.dart';
import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';

import 'cognito_service.dart';
import 'user_identity_service.dart';

final userPool = CognitoUserPool(
  dotenv.env['AWS_USER_POOL_ID']!,
  dotenv.env['AWS_CLIENT_ID']!,
  //clientSecret: DotEnv()env['AWS_CLIENT_SECRET'],
);

class UserIdentityRepository {
  final _cognitoService = CognitoService(userPool: userPool);
  final _gciService = UserIdentityService();
  final _userStorage = UserStorage();
  final _handler = ExceptionHandler();

  Future<bool?> checkAuth() async {
      try {
        final int expiration = int.parse(await _userStorage.readExpiration()??'');

        DateTime expireDate =
        DateTime.fromMillisecondsSinceEpoch(expiration * 1000);

        if (expireDate.compareTo(DateTime.now()) > 0) {
          return true;
        } else {
          final refreshToken = await _gciService
              .refreshToken(await _userStorage.readRefreshToken());
          final int newExpireDate = ((DateTime.now()
              .add(Duration(
              seconds: refreshToken!.authenticationResult.expiresIn))
              .millisecondsSinceEpoch) /
              1000)
              .round();
          await _userStorage.writeExpiration(newExpireDate.toString());
          await _userStorage
              .writeToken(refreshToken.authenticationResult.accessToken);
          return true;
        }
      } catch (e) {
        return false;
      }
  }

  Future<Result> login(
      {required String email, required String password}) async {
    try {
      UserModel user = await _gciService.login(email, password);
      await _userStorage.writeUser(user);
      if(!kIsWeb) {
        await _gciService.registerDeviceId(user.dni);
      }
      return Result(message: 'User sucessfully logged in!', data: user.dni);
    } catch (e) {
      throw _handler.analyzeException(
        error: e,
        message: 'Incorrect username or password',
      );
    }
  }

  Future<Result> signup({required String dni}) async {
    String formattedDni;

    if (dotenv.env['COUNTRY_CODE'] == "PE") {
      formattedDni = dni;
    } else {
      formattedDni = dni.replaceAll(RegExp(r'[.||-]'), '');
      formattedDni = formattedDni.substring(0, formattedDni.length - 1);
    }

    try {
      UserModel tempUser = await _gciService.signUp(formattedDni);

      final user = UserModel(
        dni: formattedDni,
        nombre: tempUser.nombre,
        email: tempUser.email,
      );

      await _userStorage.writeUser(user);

      return Result(message: 'User sign up successful!');
    } catch (e) {
      final response = (e as DioError).response?.data as Map;

      if (response['error'] == "UnconfirmedException") {
        await _cognitoService.resendConfirmationCode(response['email']);
      }
      final user = UserModel(
        dni: formattedDni,
        nombre: response['name'] ?? '',
        email: response['email'] ?? '',
      );

      await _userStorage.writeUser(user);

      e.response?.data.addAll({'message': response['error']});

      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> confirm({required String pin}) async {
    try {
      final user = await _userStorage.readUser();

      final isConfirm = await _cognitoService.confirmAccount(user?.email, pin);

      return Result(
        data: isConfirm,
        message: 'Account successfully confirmed!',
      );
    } catch (e) {
      throw _handler.analyzeException(error: e, data: false);
    }
  }

  Future<Result> resendConfirmationCode({required String email}) async {
    try {
      await _cognitoService.resendConfirmationCode(email);
      return Result(message: 'Code forwarded successfully!');
    } catch (e) {
      throw _handler.analyzeException(data: false, error: e);
    }
  }

  Future<Result> changePassword({required String newPassword}) async {
    try {
      final user = await _userStorage.readUser();

      String oldPassword =
          '${user?.dni ?? ''}-${StringUtils.capitalize(user?.nombre ?? '')}';

      await _gciService.disableForceChangePassword(user?.email);
      await _cognitoService.changePassword(user!, oldPassword, newPassword);

      return Result(data: true, message: 'Password change successfully!');
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future forgotPassword({required String email}) async {
    try {
      await _cognitoService.forgotPassword(email);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<bool> userExist({required String email}) async {
    try {
      await _gciService.userExist(email);
      return true;
    } catch (e) {
      final codeError = (e as DioError).response?.data.toString();
      return codeError!.contains('NoUserException') ||
              codeError.contains('UnconfirmedException')
          ? false
          : true;
    }
  }

  Future<Result> confirmForgotPassword(
      {required String email,
      required String confirmationCode,
      required String newPassword}) async {
    try {
      final isConfirmed = await _cognitoService.confirmForgotPassword(
          email, confirmationCode, newPassword);

      return Result(data: isConfirmed);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future signOut() async {
    await _userStorage.removeExpiration();
    await _userStorage.removeToken();
    await _userStorage.removeUser();

    await PropertyRepository.removeProperties();
    await NotificationRepository.removeNotifications();
  }
}
