import 'package:iclavis/models/video_model.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/services/files/files_repository.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends HydratedBloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoInitial()) {
    on<VideoLoaded>((event, emit) async {
      emit(VideoInProgress());

      try {
        Result result = await _filesRepository.fetchVideos(
          dni: event.dni,
          apiKey: event.apiKey,
          idProyecto: event.idProyecto,
        );

        emit(VideoSuccess(result: result));
      } on ResultException catch (e) {
        emit(VideoFailure(result: e.result!));
      }
    });
  }

  final FilesRepository _filesRepository = FilesRepository();

  @override
  VideoState? fromJson(Map<String, dynamic> data) {
    try {
      final videos = videoModelFromJson(data['value']);

      return VideoSuccess(result: Result(data: videos));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(VideoState state) {
    if (state is VideoSuccess) {
      return {'value': videoModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
