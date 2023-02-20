import 'package:dio/dio.dart';

import 'package:iclavis/utils/http/http_manager.dart';

import 'package:iclavis/models/faq_model.dart';

class FaqService {
  Future<List<FaqModel>> fetchFaq(String apiKey, int idProyecto) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.post("/preguntas-frecuentes",
        data: {'apiKey': apiKey, 'idProyecto': idProyecto});

    return faqModelFromJson(response.data as List);
  }
}
