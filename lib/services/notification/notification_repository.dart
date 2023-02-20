import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iclavis/models/notification_model.dart';
import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';

import 'notification_service.dart';

class NotificationRepository {
  final _notificationService = NotificationService();
  final _handler = ExceptionHandler();

  Future<Result> fetchNotficationHistory({
    required String dni,
    required int projectId,
    required String apiKey,
    bool? hasRefresh,
  }) async {
    try {
    /*  List<NotificationModel> storedNotifications =
          await readNotifications(projectId);

      if (!hasRefresh!) {
        if (storedNotifications.isNotEmpty) {
          return Result(data: storedNotifications);
        }
      }*/

      final appCode = dotenv.env['APP_CODE'];

      final notificationHistory =
          await _notificationService.fetchNotficationHistory(
        dni,
        projectId,
        apiKey,
        appCode!,
      );

      if (notificationHistory.isNotEmpty) {
        await writeNotification(notifications: notificationHistory);
        return Result(data: notificationHistory);
      }

      return Result(data: notificationHistory);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }



  Future<void> postReadNotification({
    required String dni,
    required int notificationId,
  }) async {
    try{
      await _notificationService.postReadNotfication(
        dni,
        notificationId,
      );
    }catch (e) {
      debugPrint(e.toString());
    }

  }

  Future<List<NotificationModel>> readNotifications(int projectId) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();

    List<NotificationModel> notifications = [];

    try {
      final storedNotifications = notificationModelFromJson(
        json.decode(prefs.getString('notifications')??''),
      );

      storedNotifications.forEach((notification) {
        notification.projectId.forEach((id) {
          if (id == projectId) {
            notifications.add(notification);
          }
        });
      });
    } catch (e) {
      return notifications;
    }

    return notifications;
  }

  Future writeNotification(
      {NotificationModel? notification,
      List<NotificationModel>? notifications}) async {
    assert(notification != null && notifications == null ||
        notifications != null && notification == null);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (notifications != null) {
      await prefs.setString(
        'notifications',
        notificationModelToJson(notifications),
      );
    } else {
      List<NotificationModel> storedNotifications;

      try {
        storedNotifications = notificationModelFromJson(
          json.decode(prefs.getString('notifications')??''),
        );
      } catch (_) {
        storedNotifications = [];
      }

      storedNotifications.add(notification!);

      await prefs.setString(
        'notifications',
        notificationModelToJson(storedNotifications),
      );
    }
  }

  static Future removeNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('notifications');
  }
}
