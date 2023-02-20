import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/models/user_support_history_gci_model.dart';
import 'package:iclavis/services/user_support/user_support_repository.dart';
import 'package:iclavis/utils/http/result.dart';

part 'history_user_support_gci_event.dart';
part 'history_user_support_gci_state.dart';

class HistoryUserSupportGciBloc
    extends HydratedBloc<HistoryUserSupportGciEvent, HistoryUserSupportGciState> {
  HistoryUserSupportGciBloc() : super(HistoryUserSupportGciInitial()){

    on<HistoryUserSupportGciLoaded>((event, emit) async {
      emit(HistoryUserSupportGciInProgress());

      try {
        final result = await _userSupportRepository.fetchHistoryGci(
          apiKey: event.apiKey,
          dni: event.dni,
          idProyecto: event.idProyecto,
        );

        emit(HistoryUserSupportGciSuccess(result: result));
      } on ResultException catch (e) {
        emit(HistoryUserSupportGciFailure(result: e.result!));
      }

    });
    on<HistoryUserSupportGciChanged>((event, emit) async {
      emit(HistoryUserSupportGciInitial());
    });
  }

  final UserSupportRepository _userSupportRepository = UserSupportRepository();

  @override
  HistoryUserSupportGciState? fromJson(Map<String, dynamic> data) {
    try {
      final projects =
          userSupportHistoryGciModelFromJson(json.decode(data['value']));

      return HistoryUserSupportGciSuccess(result: Result(data: projects));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(HistoryUserSupportGciState state) {
    if (state is HistoryUserSupportGciSuccess) {
      return {'value': userSupportHistoryGciModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
