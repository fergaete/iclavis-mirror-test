part of 'contacts_bloc.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class ContactsLoaded extends ContactsEvent {
  final String apiKey;
  final int idProyecto;

  const ContactsLoaded({
    required this.apiKey,
    required this.idProyecto,
  });

  @override
  List<Object> get props => [apiKey, idProyecto];

  @override
  String toString() =>
      'ContactsLoaded { ApiKey: $apiKey, IdProyecto: $idProyecto }';
}

class ContactsChanged extends ContactsEvent {}
