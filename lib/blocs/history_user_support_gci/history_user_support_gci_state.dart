part of 'history_user_support_gci_bloc.dart';

abstract class HistoryUserSupportGciState extends Equatable {
  const HistoryUserSupportGciState();

  @override
  List<Object> get props => [];
}

class HistoryUserSupportGciInitial extends HistoryUserSupportGciState {}

class HistoryUserSupportGciInProgress extends HistoryUserSupportGciState {}

class HistoryUserSupportGciSuccess extends HistoryUserSupportGciState {
  final Result result;

  const HistoryUserSupportGciSuccess({required this.result});

  @override
  String toString() => 'HistoryUserSupportGciSuccess { Result: $result }';
}

class HistoryUserSupportGciFailure extends HistoryUserSupportGciState {
  final Result result;

  const HistoryUserSupportGciFailure({required this.result});

  @override
  String toString() => 'HistoryUserSupportFailure { Result: $result }';
}
