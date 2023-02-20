import 'package:dio/dio.dart';

import 'package:iclavis/utils/http/http_manager.dart';

import 'package:iclavis/models/contacts_model.dart';

class ContactsService {
  Future<List<ContactsModel>> fetchContacts(
      String apiKey, int idProyecto) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.get(
      "/agenda-contacto",
      queryParameters: {'apiKey': apiKey, 'idProyecto': idProyecto},
    );

    return contactsModelFromJson(response.data as List);
  }
}
