part of 'history_user_support_request_bloc.dart';

@immutable
abstract class HistoryUserSupportRequestState {

}

class HistoryUserSupportRequestInitial extends HistoryUserSupportRequestState {}

class HistoryUserSupportRequestInProgress extends HistoryUserSupportRequestState {}

class HistoryUserSupportRequestSuccess extends HistoryUserSupportRequestState {
  final Result result;

   HistoryUserSupportRequestSuccess({required this.result});

  @override
  String toString() => 'HistoryUserSupportSuccess { Result: $result }';
}



class HistoryUserSupportRequestFailure extends HistoryUserSupportRequestState {

  final Result result;

   HistoryUserSupportRequestFailure({required this.result});

  @override
  String toString() => 'HistoryUserSupportFailure { Result: $result }';
}

