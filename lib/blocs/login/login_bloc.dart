import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/services/user_identity/user_identity_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()){

    final UserIdentityRepository _userIdentityRepository =
    UserIdentityRepository();
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginInProgress());
      try {
        final result = await _userIdentityRepository.login(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccess(result: result));
      } on ResultException catch (e) {
        emit(LoginFailure(result: e.result!));
      }
    });

  }

}
