part of 'history_user_support_gci_bloc.dart';

abstract class HistoryUserSupportGciEvent extends Equatable {
  const HistoryUserSupportGciEvent();

  @override
  List<Object> get props => [];
}

class HistoryUserSupportGciChanged extends HistoryUserSupportGciEvent {}

class HistoryUserSupportGciLoaded extends HistoryUserSupportGciEvent {
  final String apiKey;
  final String dni;
  final int idProyecto;

  const HistoryUserSupportGciLoaded({
    required this.apiKey,
    required this.dni,
    required this.idProyecto,
  });

  @override
  List<Object> get props => [apiKey, dni, idProyecto];

  @override
  String toString() =>
      'HistoryUserSupportHistoryLoaded { ApiKey: $apiKey, DNI: $dni, IdProyecto: $idProyecto}';
}
