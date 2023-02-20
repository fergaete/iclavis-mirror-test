import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/models/user_support_history_model.dart';
import 'package:iclavis/services/user_support/user_support_repository.dart';
import 'package:iclavis/utils/http/result.dart';

part 'history_user_support_event.dart';
part 'history_user_support_state.dart';

class HistoryUserSupportBloc
    extends HydratedBloc<HistoryUserSupportEvent, HistoryUserSupportState> {
  HistoryUserSupportBloc() : super(HistoryUserSupportInitial()){

    on<HistoryUserSupportLoaded>((event, emit) async {
      emit(HistoryUserSupportInProgress());

      try {
        final result = await _userSupportRepository.fetchHistory(
          apiKey: event.apiKey,
          dni: event.dni,
          idPropiedad: event.idPropiedad,
        );

          emit( HistoryUserSupportSuccess(result: result));
      } on ResultException catch (e) {
        emit( HistoryUserSupportFailure(result: e.result!));
      }
    });
    on<HistoryUserSupportChanged>((event, emit) async {
      emit( HistoryUserSupportInitial());
    });
  }

  final UserSupportRepository _userSupportRepository = UserSupportRepository();

  @override
  HistoryUserSupportState? fromJson(Map<String, dynamic> data) {
    try {
      final projects =
          userSupportHistoryModelFromJson(json.decode(data['value']));

      return HistoryUserSupportSuccess(result: Result(data: projects));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(HistoryUserSupportState state) {
    if (state is HistoryUserSupportSuccess) {
      return {'value': userSupportHistoryModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
