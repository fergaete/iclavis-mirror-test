import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:iclavis/models/user_model.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();

  StorageManager._internal();

  static StorageManager get instance => _instance;

  static dynamic _database;
  final _initStorageMemoizer = AsyncMemoizer<dynamic>();

  Box<UserModel>? userBox;

  Future get database async {
    _database ??= await _initStorageMemoizer.runOnce(() async {
        return _initStorage();
      });
  }

  Future _initStorage() async {
    final tempDir = !kIsWeb? await getApplicationDocumentsDirectory():null;

    Hive
      ..init( kIsWeb
          ? null:"${tempDir?.path}/db")
      ..registerAdapter(UserModelAdapter());

    userBox = await Hive.openBox<UserModel>('userBox');
  }
}
