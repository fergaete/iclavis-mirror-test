part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String dni;

  const SignupButtonPressed({required this.dni});

  @override
  List<Object> get props => [dni];

  @override
  String toString() => 'SignupButtonPressed { dni: $dni }';
}

class ChangePasswordButtonPressed extends SignupEvent {
  final String newPassword;

  const ChangePasswordButtonPressed({required this.newPassword});

  @override
  List<Object> get props => [newPassword];

  @override
  String toString() =>
      'ChangePasswordButtonPressed { New password: $newPassword }';
}

class ForgotPasswordButtonPressed extends SignupEvent {
  final String email;

  const ForgotPasswordButtonPressed({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class ConfirmForgotPasswordButtonPressed extends SignupEvent {
  final String email;
  final String confirmationCode;
  final String newPassword;

  const ConfirmForgotPasswordButtonPressed({
    required this.email,
    required this.confirmationCode,
    required this.newPassword,
  });

  @override
  List<Object> get props => [email, newPassword, confirmationCode];
}
