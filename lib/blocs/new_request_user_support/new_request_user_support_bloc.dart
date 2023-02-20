import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/models/user_support_category_model.dart';
import 'package:iclavis/services/user_support/user_support_repository.dart';
import 'package:iclavis/utils/http/result.dart';

part 'new_request_user_support_event.dart';
part 'new_request_user_support_state.dart';

class NewRequestUserSupportBloc extends HydratedBloc<NewRequestUserSupportEvent,
    NewRequestUserSupportState> {
  NewRequestUserSupportBloc() : super(NewRequestUserSupportInitial()){
    on<NewRequestUserSupportCategoriesLoaded>((event, emit) async {
      try {
        final result = await _userSupportRepository.fetchCategories(
          apiKey: event.apiKey,
        );

        emit(NewRequestUserSupportSuccess(result: result));
      } on ResultException catch (e) {
        emit(NewRequestUserSupportFailure(result: e.result!));
      }
    });
    on<NewRequestUserSupportCategoriesLoadedPvi>((event, emit) async {
      try {
        final result = await _userSupportRepository.fetchCategoriesPvi(
          apiKey: event.apiKey,
        );

        emit(NewRequestUserSupportSuccess(result: result));
      } on ResultException catch (e) {
        emit(NewRequestUserSupportFailure(result: e.result!));
      }

    });
    on<NewRequestUserSupportRequestSended>((event, emit) async {
      emit(NewRequestUserSupportInProgress());
      try {
        await _userSupportRepository.sendUserSupportRequest(
          apiKey: event.apiKey,
          requestBody: event.requestBody,
        );
        emit(NewRequestUserSupportSendedSuccess());
      } on ResultException catch (e) {
        emit(NewRequestUserSupportFailure(result: e.result!));
      }
    });
    on<NewRequestUserSupportRequestPviSended>((event, emit) async {

      emit(NewRequestUserSupportInProgress());

      try {
        await _userSupportRepository.sendUserSupportRequestPvi(
          apiKey: event.apiKey,
          requestBody: event.requestBody,
        );
        emit(NewRequestUserSupportSendedSuccess());
      } on ResultException catch (e) {
        emit(NewRequestUserSupportFailure(result: e.result!));
      }
    });
  }

  final UserSupportRepository _userSupportRepository = UserSupportRepository();


  @override
  NewRequestUserSupportState? fromJson(Map<String, dynamic> json) {
    try {
      final projects = userSupportCategoryModelFromJson(json['value'] as List);

      return NewRequestUserSupportSuccess(result: Result(data: projects));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(NewRequestUserSupportState state) {
    if (state is NewRequestUserSupportSuccess) {
      return {'value': userSupportCategoryModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
