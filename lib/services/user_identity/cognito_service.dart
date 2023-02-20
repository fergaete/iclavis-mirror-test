import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:iclavis/models/user_model.dart';

class CognitoService {
  late CognitoUserPool userPool;
  late CognitoUser _cognitoUser;
  late CognitoUserSession _session;
  CognitoService({required this.userPool});


  Future<bool> confirmAccount(String? email, String? confirmationCode) async {
    _cognitoUser = CognitoUser(email, userPool);

    return await _cognitoUser.confirmRegistration(confirmationCode!);
  }

  Future resendConfirmationCode(String email) async {
    _cognitoUser = CognitoUser(email, userPool);
    await _cognitoUser.resendConfirmationCode();
  }

  Future changePassword(
      UserModel user, String oldPassword, String newPassword) async {
    _cognitoUser = CognitoUser(user.email, userPool);

    await initSession(_cognitoUser, user);

    await _cognitoUser.changePassword(oldPassword, newPassword);
  }

  Future initSession(CognitoUser cognitoUser,  UserModel user) async {
    final authDetails = AuthenticationDetails(
        username: user.email,
        password: '${user.dni!}-${StringUtils.capitalize(user.nombre??'')}');

    _session = (await cognitoUser.authenticateUser(authDetails))!;
  }

  Future forgotPassword(String email) async {
    _cognitoUser = CognitoUser(email, userPool);

    await _cognitoUser.forgotPassword();
  }

  Future<bool> confirmForgotPassword(
      String email, String confirmationCode, String newPassword) async {
    _cognitoUser = CognitoUser(email, userPool);

    return await _cognitoUser.confirmPassword(confirmationCode, newPassword);
  }
}
