import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:iclavis/models/contacts_model.dart';
import 'package:iclavis/services/contacts/contacts_repository.dart';
import 'package:iclavis/utils/http/result.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends HydratedBloc<ContactsEvent, ContactsState> {
  final ContactsRepository _contactsRepository = ContactsRepository();
  ContactsBloc() : super(ContactsInitial()) {
    on<ContactsLoaded>((event, emit) async {
      emit(ContactsInProgress());
      try {
        Result result = await _contactsRepository.fetchContacts(
          apiKey: event.apiKey,
          idProyecto: event.idProyecto,
        );
        emit(ContactsSuccess(result: result));
      } on ResultException catch (e) {
        emit(ContactsFailure(result: e.result!));
      }
    });
    on<ContactsChanged>((event, emit) async {
      emit(ContactsInitial());
    });
  }

  @override
  ContactsState? fromJson(Map<String, dynamic> data) {
    try {
      final contacts = contactsModelFromJson(json.decode(data['value']));

      return ContactsSuccess(result: Result(data: contacts));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ContactsState state) {
    if (state is ContactsSuccess) {
      return {'value': contactsModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
