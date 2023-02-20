import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iclavis/blocs/contacts/contacts_bloc.dart';
import 'package:iclavis/blocs/history_user_support/history_user_support_bloc.dart';
import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/property/property_bloc.dart';

import 'package:iclavis/blocs/notification/notification_bloc.dart';

class NotificationManager {
  static final _messaging = FirebaseMessaging.instance;

  static Future<String?> getToken() => _messaging.getToken();

  static GlobalKey<NavigatorState>? _navigatorKey;

  static String? _type;
  static int? _projectId;

  static BuildContext? _context;

  static Future initialize({
    GlobalKey<NavigatorState>? navigatorKey,
    BuildContext? context,
  }) async {
    await FirebaseMessaging.instance.getToken();
    _navigatorKey = navigatorKey;
    _context = context;

    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
      onSelectNotification
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('id', 'channel',
            channelDescription: 'Iclavis notifications',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        FlutterAppBadger.updateBadgeCount(1);
        final projectsId = json.decode(message.data['projectId']);

        _type = message.data['type'];
        _projectId = projectsId.first;

        if (message.data['type'] != 'pago') {
          _context
              ?.read<NotificationBloc>()
              .add(NotificationProcessed(data: message.data));
        }

        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title,
            message.notification?.body,
            notificationDetails,
            payload: message.data['type']);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final projectsId = json.decode(event.data['projectId']);
      FlutterAppBadger.removeBadge();
      if (event.data['type'].contains('pago')) {
        navigatorKey?.currentState?.pushReplacementNamed('/payment');
      } else {
        _context
            ?.read<NotificationBloc>()
            .add(NotificationProcessed(data: event.data));
        _changeProject(projectsId.first);
        navigatorKey?.currentState?.pushReplacementNamed('/notification');
      }
    });
  }

  static void onSelectNotification(NotificationResponse response) async {
    if (_type == 'pago') {
      await _navigatorKey?.currentState?.pushReplacementNamed('/payment');
    } else {
      _changeProject(_projectId!);
      await _navigatorKey?.currentState?.pushReplacementNamed('/notification');
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    FlutterAppBadger.updateBadgeCount(1);
    if (message.data['type'] != 'pago') {
      _context
          ?.read<NotificationBloc>()
          .add(NotificationProcessed(data: message.data));
    }
  }

  static void _changeProject(int id) {
    _context?.read<ProjectBloc>().add(CurrentProjectSaved(id: id));
    _context?.read<PropertyBloc>().add(PropertyChanged());
    _context?.read<PaymentBloc>().add(PaymentAccountChanged());
    _context?.read<HistoryUserSupportBloc>().add(HistoryUserSupportChanged());
    _context?.read<ContactsBloc>().add(ContactsChanged());

    NotificationBloc.projectId = id;
  }
}
