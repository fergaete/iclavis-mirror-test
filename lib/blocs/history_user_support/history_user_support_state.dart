part of 'history_user_support_bloc.dart';

abstract class HistoryUserSupportState extends Equatable {
  const HistoryUserSupportState();

  @override
  List<Object> get props => [];
}

class HistoryUserSupportInitial extends HistoryUserSupportState {}

class HistoryUserSupportInProgress extends HistoryUserSupportState {}

class HistoryUserSupportSuccess extends HistoryUserSupportState {
  final Result result;

  const HistoryUserSupportSuccess({required this.result});

  @override
  String toString() => 'HistoryUserSupportSuccess { Result: $result }';
}

class HistoryUserSupportFailure extends HistoryUserSupportState {
  final Result result;

  const HistoryUserSupportFailure({required this.result});

  @override
  String toString() => 'HistoryUserSupportFailure { Result: $result }';
}
