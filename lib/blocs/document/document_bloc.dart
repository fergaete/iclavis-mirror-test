
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:iclavis/models/document_model.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/services/files/files_repository.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends HydratedBloc<DocumentEvent, DocumentState> {
  DocumentBloc() : super(DocumentInitial()){
    on<DocumentLoaded>((event, emit) async {
      emit(DocumentInProgress());
      try {
        Result result = await _filesRepository.fetchDocuments(
          dni: event.dni,
          apiKey: event.apiKey,
          idProyecto: event.idProyecto,
        );

          emit( DocumentSuccess(result: result));
      } on ResultException catch (e) {
        emit( DocumentFailure(result: e.result!));
      }
    });
    on<DocumentDownloaded>((event, emit) async {

      emit( DocumentDownloadInProgress());
      try {
        final result = await _filesRepository.downloadDocument(
          documentUrl: event.documentUrl,
          documentName: event.documentName,
        );

        emit( DocumentDownloadSuccess(result: result));
      } on ResultException catch (e) {
        emit( DocumentFailure(result: e.result!));
      }
    });
  }

  final FilesRepository _filesRepository = FilesRepository();


  @override
  DocumentState? fromJson(Map<String, dynamic> data) {
    try {
      final documents = documentModelFromJson(data['value']);

      return DocumentSuccess(result: Result(data: documents));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(DocumentState state) {
    if (state is DocumentSuccess) {
      return {'value': documentModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
