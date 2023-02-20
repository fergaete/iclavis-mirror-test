import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/services/notification/notification_repository.dart';
import 'package:iclavis/models/notification_model.dart';
import 'package:iclavis/utils/http/result.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc
    extends HydratedBloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository =
      NotificationRepository();

  static int? projectId;

  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationProcessed>((event, emit) async {
      List<NotificationModel> notifications = [];

      try {
        final notification = NotificationModel.pnFromJson(event.data);
        await notificationRepository.writeNotification(
          notification: notification,
        );
        if (notification.projectId.contains(projectId)) {
          if (state is NotificationSuccess) {
            notifications.addAll([...state.props.first.data, notification]);
            emit(NotificationSuccess(result: Result(data: notifications)));
          } else {
            notifications.add(notification);
            emit(NotificationSuccess(result: Result(data: notifications)));
          }
        }
      } on ResultException catch (_) {
        emit(NotificationFailure());
      } catch (_) {
        emit(NotificationFailure());
      }
    });
    on<NotificationHistoryLoaded>((event, emit) async {
      emit(NotificationInProgress());

      try {
        final result = await notificationRepository.fetchNotficationHistory(
          dni: event.dni,
          projectId: event.projectId,
          apiKey: event.apiKey,
          hasRefresh: event.hasRefresh,
        );

        emit(NotificationSuccess(result: result));
      } on ResultException catch (_) {
        emit(NotificationFailure());
      }
    });
    on<NotificationChanged>((event, emit) async {
      emit(NotificationInitial());
    });
    on<NotificationReadEvent>((event, emit) async {
      await notificationRepository.postReadNotification(
          dni: event.dni,
          notificationId: event.notificacionId
      );
      emit(NotificationReadSuccess());
    });
  }

  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    try {
      final notifications = notificationModelFromJson(json['value']);

      return NotificationSuccess(result: Result(data: notifications));
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    if (state is NotificationSuccess) {
      return {'value': notificationModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
