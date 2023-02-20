
import 'package:equatable/equatable.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/models/user_model.dart';

import '../../services/user/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepository();
  UserBloc() : super(UserInitial()){

    on<UserLoaded>((event, emit) async {
      try {
        final user = await _userRepository.fetchUser();
        emit(UserSuccess(user: user!)) ;
      } catch (_) {
        emit(UserFailure());
      }
    });

    on<UserUpdated>((event, emit) async {
      emit(UserInitial());
      try {
        //final user = await _userRepository.fetchUser();

        emit(UserSuccess(user: event.user));
      } catch (_) {
        emit(UserFailure());
      }
    });
  }


  @override
  UserState? fromJson(Map<String, dynamic> json) {
    try {
      return UserSuccess(user: userFromJson(json['value']));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    if (state is UserSuccess) {
      return {'value': userToJson(state.user)};
    } else {
      return null;
    }
  }
}
