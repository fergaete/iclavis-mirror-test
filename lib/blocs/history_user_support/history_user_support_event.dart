part of 'history_user_support_bloc.dart';

abstract class HistoryUserSupportEvent extends Equatable {
  const HistoryUserSupportEvent();

  @override
  List<Object> get props => [];
}

class HistoryUserSupportChanged extends HistoryUserSupportEvent {}

class HistoryUserSupportLoaded extends HistoryUserSupportEvent {
  final String apiKey;
  final String dni;
  final int idPropiedad;

  const HistoryUserSupportLoaded({
    required this.apiKey,
    required this.dni,
    required this.idPropiedad,
  });

  @override
  List<Object> get props => [apiKey, dni, idPropiedad];

  @override
  String toString() =>
      'HistoryUserSupportHistoryLoaded { ApiKey: $apiKey, DNI: $dni, IdProyecto: $idPropiedad}';
}
