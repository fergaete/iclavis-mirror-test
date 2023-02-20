part of 'video_bloc.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class VideoLoaded extends VideoEvent {
  final String dni;
  final String apiKey;
  final int idProyecto;

  const VideoLoaded({
    required this.dni,
    required this.apiKey,
    required this.idProyecto,
  });

  @override
  List<Object> get props => [dni, apiKey, idProyecto];

  @override
  String toString() =>
      'VideoLoaded { Dni: $dni, ApiKey: $apiKey, IdProyecto: $idProyecto}';
}
