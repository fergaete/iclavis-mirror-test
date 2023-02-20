import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:iclavis/utils/http/http_manager.dart';
import 'package:iclavis/models/project_model.dart';

class ProjectService {
  Future<List<ProjectModel>> fetchProject(String dni) async {
    final httpClient = HttpManager.instance.withTokenPlanok;
    final sharedSecret = dotenv.env['SHARED_SECRET'];
    final apiKey = dotenv.env['API_KEY'];
    Response response = await httpClient.get(
      "/inmobiliarias-proyectos-usuario/$dni${Customization.personalizable?'?apikey=$apiKey':''}",
      queryParameters: {'sharedSecret': sharedSecret},
    );
    return projectModelFromJson(response.data as List);
  }
}
