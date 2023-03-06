import 'package:iclavis/environment.dart';
import 'package:iclavis/models/notification_model.dart';
import 'package:iclavis/utils/http/http_manager.dart';

class NotificationService {
  Future<List<NotificationModel>> fetchNotficationHistory(
      String dni, int projectId, String apiKey, String appCode) async {
    final httpClient = HttpManager.instance.withToken;

    final response = await httpClient.get(
      '/historial-notificaciones-push',
      queryParameters: {
        'rut': dni,
        'proyectoId': projectId,
        'apiKey': apiKey,
        'codigoAplicacion': appCode
      },
    );

    return notificationModelFromJson(response.data);
  }

  Future<void> postReadNotfication(
      String dni, int notificationId) async {
    final appCode =  Environment.APP_CODE;
    final httpClient = HttpManager.instance.withToken;

    final response = await httpClient.post(
      '/notificacion-abierta',
      queryParameters: {
        'codigoAplicacion': appCode
      },
      data: {
        'rut': dni,
        'idNotificacion': notificationId,
      },
    );

  }
}
