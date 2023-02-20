import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iclavis/services/notification/notification_manager.dart';

import '../blocs/simple_bloc_observer.dart';
import 'firebase_config.dart';

class InitialConfig {
  static init() async {
    await FirebaseConfig.initializeFirebaseApp();
    Bloc.observer = SimpleBlocObserver();
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    await dotenv.load(fileName: 'env');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    FirebaseMessaging.onBackgroundMessage(
      NotificationManager.firebaseMessagingBackgroundHandler,
    );
  }
}
