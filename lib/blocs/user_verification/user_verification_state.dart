part of 'user_verification_bloc.dart';

abstract class UserVerificationState extends Equatable {
  const UserVerificationState();

  @override
  List<Object> get props => [];
}

class UserVerificationInitial extends UserVerificationState {
  final Result result;

  UserVerificationInitial({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "UserVerificationInitial Result: $result";
}

class UserVerificationInProgress extends UserVerificationState {}

class ConfirmSuccess extends UserVerificationState {
  final Result result;

  ConfirmSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "ConfirmSuccess Result: $result";
}

class ResendCodeSuccess extends UserVerificationState {
  final Result result;

  ResendCodeSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "ResendCodeSuccess Result: $result";
}

class UserVerificationFailure extends UserVerificationState {
  final Result result;

  UserVerificationFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "UserVerificationFailure Result: $result";
}
