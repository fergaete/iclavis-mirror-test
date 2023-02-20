import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';

import 'result.dart';

import 'package:iclavis/routes/routes.dart';

class ExceptionHandler {
  static final ExceptionHandler _instance = ExceptionHandler._internal();

  ExceptionHandler._internal();

  factory ExceptionHandler() => _instance;

  Exception analyzeException({dynamic error, dynamic data, String? message}) {
    String? _message;

    switch (error.runtimeType) {
      case CognitoClientException:
        _message = 'CognitoClientException';

        if (error.code == 'NotAuthorizedException') {
          _message = error.code;
        } else if (error.code == 'CodeMismatchException') {
          _message = 'signup.Excepcion_codigo_incorrecto';
        } else if (error.code == 'InvalidPasswordException') {
          _message = 'Contraseña inválida';
        } else if (error.code == 'LimitExceededException') {
          _message = 'Límite de intentos excedido';
        } else {
          _message = 'server';
        }
        return ResultException(
            error: error, data: data, message: message ?? _message);

      case DioError:
        if (error.error.toString().contains('Failed host lookup')) {
          _message = 'server';
        } else if (error.type == DioErrorType.connectTimeout) {
          _message = 'server';
        }  else if (error.response == null) {
          return ResultException<DioError>(
            error: error,
            message: 'server',
          );
        } else if (error.response?.statusCode == 502) {
          _message = 'server';
        } else if (error.response?.statusCode == 504) {
          _message = 'server';
        } else if (error.response?.data['message'] ==
            'forceChangePasswordException') {
          return ResultException<DioError>(
              error: error,
              data: RoutePaths.SetPassword,
              message: 'Debe cambiar su contraseña');
        } else if (error.response?.data['message'] == 'UnconfirmedException') {
          return ResultException<DioError>(
              error: error,
              data: RoutePaths.UserVerification,
              message: 'Usuario no registrado');
        } else if (error.response?.data['message'] == 'NoUserException') {
          return ResultException<DioError>(
            error: error,
            message: 'Usuario no registrado',
          );
        } else if (error.response?.data['message'] ==
            'UsernameExistsException') {
          return ResultException<DioError>(
              error: error, message: 'signup.user_already_exists_id_invalid_exception');
        } else if (error.response?.data['message']!=null) {
          if (error.response?.data['message'].contains(
              'NotAuthorizedException')) {
            return ResultException<DioError>(
              error: error,
              message: 'login.login_fail_userpass',
            );
          }
        }else if (error.response?.data['message'] ==
            'Usuario sin negocio Válido') {
          return ResultException<DioError>(
            error: error,
            message: 'signup.user_not_found_exception',
          );
        }else if (error.response?.data['FAIL'] !=null ) {
          return ResultException<DioError>(
            error: error,
            message: error.response?.data['FAIL']['mensajeError'],
          );
        }

        _message = _message ?? message ?? error.response.data['message'];

        return ResultException(error: error, message: _message);

      default:
        return ResultException(
          error: error,
          data: data,
          message: message ?? error.toString(),
        );
    }
  }
}
