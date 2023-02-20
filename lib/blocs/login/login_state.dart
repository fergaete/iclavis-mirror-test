part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final Result result;

  const LoginSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'LoginSuccess { Result: $result }';
}

class LoginFailure extends LoginState {
  final Result result;

  const LoginFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'LoginFailure { Result: $result }';
}
