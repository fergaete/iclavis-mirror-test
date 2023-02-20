import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/services/user_identity/user_identity_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

// ignore: constant_identifier_names
enum EventType { SignUp, Confirm, ChangePassword, ResendCode }

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserIdentityRepository _userIdentityRepository =
      UserIdentityRepository();

  SignupBloc() : super(SignupInitial()) {
    on<SignupButtonPressed>((event, emit) async {
      emit(const SignupInProgress(eventType: EventType.SignUp));
      try {
        final result = await _userIdentityRepository.signup(
          dni: event.dni,
        );
        emit(SignupSuccess(result: result));
      } on ResultException catch (e) {
        emit(SignupFailure(result: e.result!));
      } catch (e) {
        emit(const SignupFailure(result: null));
      }
    });

    on<ChangePasswordButtonPressed>((event, emit) async {
      emit(const SignupInProgress(eventType: EventType.ChangePassword));
      try {
        final result = await _userIdentityRepository.changePassword(
          newPassword: event.newPassword,
        );
        emit(SignupSuccess(result: result));
      } on ResultException catch (e) {
        emit(SignupFailure(result: e.result));
      }
    });

    on<ForgotPasswordButtonPressed>((event, emit) async {
      emit(ForgotPasswordButtonInProgress());
      try {
        final isUser =
            await _userIdentityRepository.userExist(email: event.email);

        if (isUser) {
          await _userIdentityRepository.forgotPassword(email: event.email);
          emit(ForgotPasswordButtonSuccess());
        } else {
          emit(const ForgotPasswordButtonFailure(error: 'Usuario no existe'));
        }
      } on ResultException catch (e) {
        emit(ForgotPasswordButtonFailure(error: e.error.toString()));
      }
    });
    on<ConfirmForgotPasswordButtonPressed>((event, emit) async {
      emit(ConfirmForgotPasswordButtonInProgress());

      try {
        await _userIdentityRepository.confirmForgotPassword(
          email: event.email,
          confirmationCode: event.confirmationCode,
          newPassword: event.newPassword,
        );

        emit(ConfirmForgotPasswordButtonSuccess());
      } on ResultException catch (e) {
        emit(ForgotPasswordFailure(result: e.result!));
      }
    });
  }

  /* @override
  SignupState fromJson(Map<String, dynamic> json) =>
      SignupSuccess(result: Result.fromJson(json['value']));

  @override
  Map<String, dynamic> toJson(SignupState state) =>
      {'value': state.prop.toJson()}; */
}
