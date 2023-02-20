import 'dart:async';

import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/services/user_storage/user_storage.dart';

class UserRepository {
  final UserStorage _userStorage = UserStorage();

  Future<UserModel?> fetchUser() async {
    try {
      return await _userStorage.readUser();
    } catch (e) {
      rethrow;
    }
  }
  Future removeUser() async {
    try {
      await _userStorage.removeUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> readFirstStartFlag() async {
    try {
      return await _userStorage.readFirstStartFlag();
    } catch (e) {
      rethrow;
    }
  }

  Future writeFirstStartFlag() async {
    try {
      await _userStorage.writeFirstStartFlag();
    } catch (e) {
      rethrow;
    }
  }
}
