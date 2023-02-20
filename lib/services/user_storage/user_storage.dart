import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/utils/storage/storage_manager.dart';

class UserStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> readExpiration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? expiration;
    try {
      expiration = prefs.getString('expiration');
    } catch (e) {
      return null;
    }

    return expiration;
  }

  Future writeExpiration(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('expiration', value);
  }

  Future removeExpiration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final expiration = readExpiration();
    if (expiration != null) {
      await prefs.remove('expiration');
      return expiration;
    }
    return null;
  }

  Future<bool?> readFirstStartFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? firstStartFlag;
    try {
      firstStartFlag = prefs.getBool('firstStartFlag');
    } catch (e) {
      return null;
    }

    return firstStartFlag ?? false;
  }

  Future writeFirstStartFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('firstStartFlag', true);
  }

  Future removeFirstStartFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final firstStartFlag = readExpiration();
    if (firstStartFlag != null) {
      await prefs.remove('firstStartFlag');
      return firstStartFlag;
    }
    return null;
  }

  Future? readToken() async {
    String item;
    try {
      item = json.decode(await _storage.read(key: 'token')??'');
    } catch (e) {
      return null;
    }

    return item;
  }

  Future readRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  Future writeToken(String value) async {
    await _storage.write(key: 'token', value: json.encode(value));
  }

  Future writeRefreshToken(String value) async {
    await _storage.write(key: 'refreshToken', value: value);
  }

  Future removeToken() async {
    final item = readToken();
    if (item != null) {
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'refreshToken');
      return item;
    }
    return null;
  }

  Future<UserModel?> readUser() async {
    await StorageManager.instance.database;
    return StorageManager.instance.userBox?.get('user');
  }

  Future writeUser(UserModel user) async {
    await StorageManager.instance.database;
    await StorageManager.instance.userBox?.put('user', user);
  }

  Future removeUser() async {
    await StorageManager.instance.database;
    await StorageManager.instance.userBox?.delete('user');
  }

  setReadAlert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pviAlert', true);
  }
  Future<bool>readAlet() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('pviAlert')?? false;
}

}
