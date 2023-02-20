import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:iclavis/models/image_model.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/services/files/files_repository.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends HydratedBloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<ImageLoaded>((event, emit) async {
      emit(ImageInProgress());

      try {
        Result result = await _filesRepository.fetchImages(
          dni: event.dni,
          apiKey: event.apiKey,
          idProyecto: event.idProyecto,
        );

        emit(ImageSuccess(result: result));
      } on ResultException catch (e) {
        emit(ImageFailure(result: e.result!));
      }
    });
  }

  final FilesRepository _filesRepository = FilesRepository();

  @override
  ImageState? fromJson(Map<String, dynamic> data) {
    try {
      final images = imageModelFromJson(data['value']);

      return ImageSuccess(result: Result(data: images));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ImageState state) {
    if (state is ImageSuccess) {
      try {
        return {'value': imageModelToJson(state.result.data)};
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
