import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:iclavis/services/user/user_repository.dart';

part 'first_start_event.dart';
part 'first_start_state.dart';

class FirstStartBloc extends Bloc<FirstStartEvent, FirstStartState> {
  final UserRepository _userRepository = UserRepository();

  FirstStartBloc() : super(FirstStartInitial()) {
    on<FirstStartFlagSaved>((event, emit) async {
      try {
        await _userRepository.writeFirstStartFlag();
      } catch (_) {
        emit(FirstStartFailure());
      }
    });
    on<FirstStartFlagLoaded>((event, emit) async {
      try {
        final hasFirstStart = await _userRepository.readFirstStartFlag();
        emit(FirstStartSuccess(hasFirstStart: hasFirstStart!));
      } catch (_) {
        emit(FirstStartFailure());
      }
    });
  }
}
