import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:iclavis/services/faq/faq_repository.dart';
import 'package:iclavis/models/faq_model.dart';
import 'package:iclavis/utils/http/result.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class FaqBloc extends HydratedBloc<FaqEvent, FaqState> {
  FaqBloc() : super(FaqInitial()) {
    on<FaqLoaded>((event, emit) async {
      emit(FaqInProgress());

      try {
        Result result = await _faqRepository.fetchFaq(
          apiKey: event.apiKey,
          idProyecto: event.idProyecto,
        );

        emit(FaqSuccess(result: result));
      } on ResultException catch (e) {
        emit(FaqFailure(result: e.result!));
      }
    });
  }

  final FaqRepository _faqRepository = FaqRepository();

  @override
  FaqState? fromJson(Map<String, dynamic> data) {
    try {
      final payment = faqModelFromJson(json.decode(data['value']));

      return FaqSuccess(result: Result(data: payment));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(FaqState state) {
    if (state is FaqSuccess) {
      return {'value': faqModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
