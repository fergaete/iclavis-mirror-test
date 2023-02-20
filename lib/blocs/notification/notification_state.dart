part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Result> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationInProgress extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final Result result;

  const NotificationSuccess({required this.result});

  @override
  List<Result> get props => [result];

  @override
  String toString() => 'NotificationSuccess { Notifications: $result }';
}

class NotificationFailure extends NotificationState {}

class NotificationReadSuccess  extends NotificationState {}