part of 'history_user_support_request_bloc.dart';

@immutable
abstract class HistoryUserSupportRequestEvent {}

class HistoryUserSupportRequestLoaded extends HistoryUserSupportRequestEvent {
  final String apiKey;
  final String dni;
  final int idProyecto;
  final String idRequest;

   HistoryUserSupportRequestLoaded({
    required this.apiKey,
    required this.dni,
    required this.idProyecto,
     required this.idRequest
  });

  @override
  List<Object> get props => [apiKey, dni, idProyecto,idRequest];

  @override
  String toString() =>
      'HistoryUserSupportHistoryLoaded { ApiKey: $apiKey, DNI: $dni, IdProyecto: $idProyecto}';
}
