import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/models/document_model.dart';
import 'package:iclavis/models/image_model.dart';
import 'package:iclavis/models/video_model.dart';

import 'files_service.dart';

class FilesRepository {
  final _filesService = FilesService();
  final _handler = ExceptionHandler();

  Future<Result> fetchDocuments(
      {required String dni, required String apiKey, required int idProyecto}) async {
    try {
      List<DocumentModel> documents = await _filesService.fetchDocument(
        dni,
        apiKey,
        idProyecto,
      );

      return Result(data: documents);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchImages(
      {required String dni, required String apiKey,required int idProyecto}) async {
    try {
      List<ImageModel> images = await _filesService.fetchImage(
        dni,
        apiKey,
        idProyecto,
      );

      return Result(data: images);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchVideos(
      {required String dni,required String apiKey, required int idProyecto}) async {
    try {
      List<VideoModel> videos = await _filesService.fetchVideo(
        dni,
        apiKey,
        idProyecto,
      );

      return Result(data: videos);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> downloadDocument(
      {required String documentUrl, required String documentName}) async {
    try {
      String pathFile =
          await _filesService.downloadDocument(documentUrl, documentName);

      return Result(data: pathFile, message: 'Descarga exitosa!');
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }
}
