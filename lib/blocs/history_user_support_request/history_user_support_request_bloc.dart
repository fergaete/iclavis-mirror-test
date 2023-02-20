import 'package:bloc/bloc.dart';
import 'package:iclavis/services/user_support/user_support_repository.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:meta/meta.dart';

part 'history_user_support_request_event.dart';
part 'history_user_support_request_state.dart';

class HistoryUserSupportRequestBloc extends Bloc<HistoryUserSupportRequestEvent, HistoryUserSupportRequestState> {
  HistoryUserSupportRequestBloc() : super(HistoryUserSupportRequestInitial()){

    on<HistoryUserSupportRequestLoaded>((event, emit) async {
      emit(HistoryUserSupportRequestInProgress());

      try {
        final result = await _userSupportRepository.fetchHistoryRequest(
            apiKey: event.apiKey,
            dni: event.dni,
            idProyecto: event.idProyecto,
            idRequest: event.idRequest
        );

        emit(HistoryUserSupportRequestSuccess(result: result));
      } on ResultException catch (e) {
        emit(HistoryUserSupportRequestFailure(result: e.result!));
      }

    });

  }
  final UserSupportRepository _userSupportRepository = UserSupportRepository();

}
