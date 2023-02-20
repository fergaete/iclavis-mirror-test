part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];

  Result get prop => Result();
}

class SignupInitial extends SignupState {}

class SignupInProgress extends SignupState {
  final EventType eventType;

  const SignupInProgress({required this.eventType});

  @override
  List<Object> get props => [eventType];

  @override
  String toString() => 'SignupSuccess { EventType: $eventType }';
}

class SignupSuccess extends SignupState {
  final Result result;

  const SignupSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  Result get prop => result;

  @override
  String toString() => 'SignupSuccess { Result: $result }';
}

class SignupFailure extends SignupState {
  final Result? result;

  const SignupFailure({required this.result});

  @override
  List<Object> get props => [result??''];

  @override
  String toString() => 'SignupFailure { Result: $result }';
}

class ForgotPasswordButtonInProgress extends SignupState {}

class ForgotPasswordButtonSuccess extends SignupState {}

class ForgotPasswordButtonFailure extends SignupState {
  final String error;

  const ForgotPasswordButtonFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ForgotPasswordButtonFailure { Error: $error }';
}

class ForgotPasswordSuccess extends SignupState {}

class ForgotPasswordFailure extends SignupState {
  final Result result;

  const ForgotPasswordFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ForgotPasswordFailure { Result: $result }';
}

class ConfirmForgotPasswordButtonInProgress extends SignupState {}

class ConfirmForgotPasswordButtonSuccess extends SignupState {}
