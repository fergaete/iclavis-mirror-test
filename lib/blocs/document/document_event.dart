part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object> get props => [];
}

class DocumentLoaded extends DocumentEvent {
  final String dni;
  final String apiKey;
  final int idProyecto;

  const DocumentLoaded({
    required this.dni,
    required this.apiKey,
    required this.idProyecto,
  });

  @override
  List<Object> get props => [dni, apiKey, idProyecto];

  @override
  String toString() =>
      'DocumentDownloaded { Dni: $dni, ApiKey: $apiKey, IdProyecto: $idProyecto}';
}

class DocumentDownloaded extends DocumentEvent {
  final String documentUrl;
  final String documentName;

  const DocumentDownloaded(
      {required this.documentUrl, required this.documentName});

  @override
  List<Object> get props => [documentUrl, documentName];

  @override
  String toString() =>
      'DocumentDownloaded { URL: $documentUrl, Name: $documentName }';
}
