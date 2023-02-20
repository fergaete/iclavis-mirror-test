

import 'package:iclavis/services/user_identity/user_identity_repository.dart';

import 'package:iclavis/utils/http/result.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_verification_event.dart';
part 'user_verification_state.dart';

class UserVerificationBloc
    extends Bloc<UserVerificationEvent, UserVerificationState> {
  UserVerificationBloc()
      : super(
          UserVerificationInitial(result: Result(data: false)),
        ){
    final UserIdentityRepository _userIdentityRepository =
    UserIdentityRepository();
    on<ConfirmButtonPressed>((event, emit) async {
      emit(UserVerificationInProgress());

      try {
        final result = await _userIdentityRepository.confirm(
          pin: event.pin,
        );

        emit(ConfirmSuccess(result: result));
      } on ResultException catch (e) {
        emit(UserVerificationFailure(result: e.result!));
      }

    });
    on<ResendCodeButtonPressed>((event, emit) async {
      emit(UserVerificationInProgress());
      try {
        final result = await _userIdentityRepository.resendConfirmationCode(
          email: event.email,
        );
        emit(ResendCodeSuccess(result: result));
      } on ResultException catch (e) {
        emit(UserVerificationFailure(result: e.result!));
      }

    });
  }
}
