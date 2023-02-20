import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/models/contacts_model.dart';

import 'contacts_service.dart';

class ContactsRepository {
  final _contactsService = ContactsService();
  final _handler = ExceptionHandler();

  Future<Result> fetchContacts({required String apiKey, required int idProyecto}) async {
    try {
      List<ContactsModel> contacts = await _contactsService.fetchContacts(
        apiKey,
        idProyecto,
      );

      return Result(data: contacts);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }
}
