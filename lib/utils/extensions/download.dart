import 'package:iclavis/services/files/files_repository.dart';
import 'package:open_filex/open_filex.dart';

class DownloadUtil{
  final FilesRepository _filesRepository = FilesRepository();

  Future<void> download(String url,String name ) async {

    final result = await _filesRepository.downloadDocument(
      documentUrl: url,
      documentName: name,
    );

    if(result.data!='') {
      await OpenFilex.open(result.data);
    }
  }

}