part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationProcessed extends NotificationEvent {
  final Map<String, dynamic> data;

  const NotificationProcessed({required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() =>
      'NotificationProcessed { Data: $data }';
}

class NotificationChanged extends NotificationEvent {}

class NotificationHistoryLoaded extends NotificationEvent {
  final String dni;
  final int projectId;
  final String apiKey;
  final bool hasRefresh;

  const NotificationHistoryLoaded({
    required this.dni,
    required this.projectId,
    required this.apiKey,
    this.hasRefresh = false,
  });

  @override
  List<Object> get props => [dni, projectId, apiKey, hasRefresh];

  @override
  String toString() =>
      'NotificationHistoryLoaded { DNI: $dni, ProjectId: $projectId, ApiKey: $apiKey, HasRefresh: $hasRefresh }';
}

class NotificationReadEvent extends NotificationEvent {
  final String dni;
  final int notificacionId;

  const NotificationReadEvent({
    required this.dni,
    required this.notificacionId,

  });

  @override
  List<Object> get props => [dni, notificacionId];
}
