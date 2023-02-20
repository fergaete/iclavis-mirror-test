part of 'new_request_user_support_bloc.dart';

abstract class NewRequestUserSupportState extends Equatable {
  const NewRequestUserSupportState();

  @override
  List<Object> get props => [];
}

class NewRequestUserSupportInitial extends NewRequestUserSupportState {}

class NewRequestUserSupportInProgress extends NewRequestUserSupportState {}

class NewRequestUserSupportSuccess extends NewRequestUserSupportState {
  final Result result;

  const NewRequestUserSupportSuccess({required this.result});

  /* @override
  List<Object> get props => [result]; */

  @override
  String toString() => 'NewRequestUserSupportSuccess { Result: $result }';
}

class NewRequestUserSupportSendedSuccess extends NewRequestUserSupportState {}

class NewRequestUserSupportFailure extends NewRequestUserSupportState {
  final Result result;

  const NewRequestUserSupportFailure({required this.result});

/*   @override
  List<Object> get props => [result]; */

  @override
  String toString() => 'NewRequestUserSupportFailure { Result: $result }';
}
