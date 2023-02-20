part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ImageLoaded extends ImageEvent {
  final String dni;
  final String apiKey;
  final int idProyecto;

  const ImageLoaded({
    required this.dni,
    required this.apiKey,
    required this.idProyecto,
  });

  @override
  List<Object> get props => [dni, apiKey, idProyecto];

  @override
  String toString() =>
      'ImageLoaded { Dni: $dni, ApiKey: $apiKey, IdProyecto: $idProyecto}';
}
