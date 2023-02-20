part of 'user_verification_bloc.dart';

abstract class UserVerificationEvent extends Equatable {
  const UserVerificationEvent();

  @override
  List<Object> get props => [];
}

class ConfirmButtonPressed extends UserVerificationEvent {
  final String pin;

  const ConfirmButtonPressed({required this.pin});

  @override
  List<Object> get props => [pin];

  @override
  String toString() => "ConfirmButtonPressed { pin: $pin }";
}

class ResendCodeButtonPressed extends UserVerificationEvent {
  final String email;

  const ResendCodeButtonPressed({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'ResendCodeButtonPressed { Email: $email }';
}
