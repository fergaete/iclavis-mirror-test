import 'package:dio/dio.dart';

import 'package:iclavis/utils/http/http_manager.dart';

import 'package:iclavis/models/property_model.dart';

class PropertyService {
  Future<PropertyModel> fetchProperty(String dni, int id, String apiKey) async {
    final httpClient = HttpManager.instance.withTokenPlanok;
    Response response = await httpClient.get(
      "/datos-propiedad",
      queryParameters: {'rutDNI': dni, 'idProyecto': id, 'apiKey': apiKey},
    );

    return propertyModelFromJson(response.data);
  }
}
