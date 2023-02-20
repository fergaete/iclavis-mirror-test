import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:iclavis/utils/http/http_manager.dart';
import 'package:iclavis/services/notification/notification_manager.dart';
import 'package:iclavis/models/user_model.dart';

import '../../models/refresh_token_model.dart';

class UserIdentityService {
  Future<bool> verifyToken() async {
    final httpClient = HttpManager.instance.withToken;

    await httpClient.get('/test');

    return true;
  }

  Future<UserModel> login(String email, String password) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.post(
      '/login',
      data: {"email": email, "password": password},
    );

    return UserModel.fromJson(response.data);
  }

  Future<UserModel> signUp(String dni) async {
    final httpClient = HttpManager.instance.init;

    Response response = await httpClient.post(
      "/registro-inicial-propietario",
      data: {"rut": dni},
    );

    return UserModel.fromJson(response.data);
  }

  Future disableForceChangePassword(String? email) async {
    final httpClient = HttpManager.instance.init;
    await httpClient.post("/set-force-change-pass", data: {"email": email});
  }

  Future registerDeviceId(String? dni) async {
    final httpClient = HttpManager.instance.init;

    final deviceId = await NotificationManager.getToken();

    debugPrint('$deviceId $dni');

    await httpClient.post(
      '/registro-dispositivo',
      data: {"rutDNI": dni, "idDispositivo": deviceId},
    );
  }

  Future userExist(String email) async {

    final httpClient = HttpManager.instance.withToken;

    await httpClient.post(
      '/login',
      data: {"email": email, "password": '123P'},
    );
  }

  Future<RefreshToken?> refreshToken(String refreshToken) async {
    final httpClient = HttpManager.instance.init;

    try{
      Response response = await httpClient.post(
        "/refresh-token",
        data: {"refreshToken":refreshToken },
      );
      return RefreshToken.fromMap(response.data);
    }catch(e){

      return null;
    }

  }

}
