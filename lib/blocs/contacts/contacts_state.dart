part of 'contacts_bloc.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsInProgress extends ContactsState {}

class ContactsSuccess extends ContactsState {
  final Result result;

  const ContactsSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ContactsSuccess { Result: $result }';
}

class ContactsFailure extends ContactsState {
  final Result result;

  const ContactsFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ContactsFailure { Result: $result }';
}
