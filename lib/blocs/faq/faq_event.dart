part of 'faq_bloc.dart';

abstract class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object> get props => [];
}

class FaqLoaded extends FaqEvent {
  final String apiKey;
  final int idProyecto;

  const FaqLoaded({required this.apiKey, required this.idProyecto});

   @override
  List<Object> get props => [apiKey, idProyecto];

  @override
  String toString() => 'FaqLoaded { ApiKey: $apiKey, IdProyecto: $idProyecto }';
}
