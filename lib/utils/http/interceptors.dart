import 'dart:io';
import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';

import 'package:iclavis/services/user_storage/user_storage.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
 /* @override
  Future onError(DioError err,ErrorInterceptorHandler handler,) async {
    if (_shouldRetry(err)) {
      try {
        return scheduleRequestRetry(err.request);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException;
  }

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription streamSubscription;

    final Dio dio = Dio();

    final responseCompleter = Completer<Response>();

    responseCompleter.complete(
      dio.request(
        requestOptions.path,
        cancelToken: requestOptions.cancelToken,
        data: requestOptions.data,
        onReceiveProgress: requestOptions.onReceiveProgress,
        onSendProgress: requestOptions.onSendProgress,
        queryParameters: requestOptions.queryParameters,
        options: requestOptions.,
      ),
    );

    return responseCompleter.future;
  }*/
}

class TokenInterceptors extends InterceptorsWrapper {

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final userStorage = UserStorage();

    final token = await userStorage.readToken();

    options.headers.addAll({'Token': token});

    return super.onRequest(options,handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.path.contains('login')) {
      final userStorage = UserStorage();

      await userStorage.writeToken(response.data['accessToken']);
      await userStorage.writeRefreshToken(response.data['refreshToken']);
      await userStorage.writeExpiration(response.data['expiration'].toString());
    }

    return super.onResponse(response,handler);
  }
}


