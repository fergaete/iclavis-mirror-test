import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:iclavis/models/user_support_history_gci_model.dart';
import 'package:iclavis/models/user_support_history_model.dart';
import 'package:iclavis/models/user_support_history_request_model.dart';
import 'package:iclavis/models/user_support_problem_model.dart';
import 'package:iclavis/models/user_support_type_warranty.dart';

import 'package:iclavis/utils/http/http_manager.dart';

import 'package:iclavis/models/user_support_category_model.dart';

class UserSupportService {
  Future<List<UserSupportCategoryModel>> fetchUserSupportCategories(
      String apiKey) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.get(
      "/tipo-consultas",
      queryParameters: {'apiKey': apiKey},
    );
    return userSupportCategoryModelFromJson(response.data as List);
  }

  Future<List<UserSupportCategoryModel>> fetchUserSupportCategoriesPvi(
      String apiKey) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get("/tipostarea", queryParameters: {
      'key': apiKey,
    });

    return userSupportCategoryModelFromJson(response.data as List);
  }

  Future sendUserSupportRequest(
      String apiKey, Map<String, dynamic> requestBody) async {
    final httpClient = HttpManager.instance.withToken;

    requestBody.forEach((key, value) {
      if (value.runtimeType is String) {
        debugPrint(value);
      }
    });

    await httpClient.post(
      "/ingresar-consulta",
      queryParameters: {'apiKey': apiKey},
      data: requestBody,
    );
  }

  Future sendUserSupportPviRequest(
      String apiKey, Map<String, dynamic> requestBody) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response result = await httpClient.post(
      "/solicitudesSac",
      data: FormData.fromMap(requestBody),
    );

    print(result);
  }

  Future<Response> sendPostSaleFormApplicationPvi(
      String apiKey, int idProduct) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.post(
      "/solicitudes",
      data: FormData.fromMap({
        'key': apiKey,
        'idProducto': idProduct,
        'medioIngreso': 'APP PROPIETARIOS'
      }),
    );

    return response;
  }

  Future<Response> sendPostSaleRequest(
      String apiKey, Map<String, dynamic> requestBody,
      [List<FilePost>? files]) async {
    final httpClient = HttpManager.instance.withTokenPvi;
    var formData = FormData.fromMap(requestBody);

    if (files != null) {
        files.forEach((e)  async  {
          formData.files.addAll([
          //  MapEntry("documentos[]", await MultipartFile.fromFile(e.file?.path ??''))
            MapEntry("documentos[]", MultipartFile.fromBytes(e.fileWeb! ,filename: "byte${e.name}")),
           // MapEntry("documentos[]", MultipartFile.fromBytes(await e.file!.readAsBytes() ,filename: "3${e.name}"))
          ]);
        });
    }

    Response response = await httpClient.post(
      "/requerimientos",
      data: formData,
    );
    return response;
  }

  Future<List<UserSupportHistoryGciModel>> fetchUserSupportHistoryGci(
      String apiKey, String dni, int idProyecto) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.get(
      "/historial-consulta",
      queryParameters: {'apiKey': apiKey, 'rut': dni, 'idProyecto': idProyecto},
    );

    return userSupportHistoryGciModelFromJson(response.data as List);
  }

  Future<List<UserSupportHistoryModel>> fetchUserSupportHistory(
      String apiKey, String dni, int idPropiedad) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get(
      "/solicitudes",
      queryParameters: {
        'idPropiedad': idPropiedad,
        'key': apiKey,
      },
    );

    return userSupportHistoryModelFromJson(response.data as List);
  }

  Future<List<UserSupportHistoryRequestModel>> fetchUserSupportHistoryRequest(
      String apiKey, String dni, int idProyecto, String request) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get(
      "/requerimientos",
      queryParameters: {'idSolicitud': request, 'key': apiKey},
    );

    return UserSupportHistoryRequestModelFromJson(response.data as List);
  }

  Future<List<Problema>> fetchUserSupportProblema( String apiKey, int? idTipoCasa,
      int? idItem, int? idLugar, int? idRecinto) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get(
      "/problemas",
      queryParameters: {
        'idTipoCasa': idTipoCasa,
        'idItem': idItem,
        'idLugar': idLugar,
        'idRecinto': idRecinto,
        'key': apiKey,
      },
    );
    return problemaFromMap(response.data as List);
  }

  Future<List<Recinto>> fetchUserSupportRecinto(String apiKey, int? idTipoCasa,
      int? idItem, int? idLugar, int? idProblema) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get(
      "/recintos",
      queryParameters: {
        'idTipoCasa': idTipoCasa,
        'idItem': idItem,
        'idLugar': idLugar,
        'idProblema': idProblema,
        'key': apiKey,
      },
    );
    return recintoFromMap(response.data as List);
  }

  Future<List<Lugar>> fetchUserSupportLugar(String apiKey, int? idTipoCasa,
      int? idItem, int? idProblema, int? idRecinto) async {
    final httpClient = HttpManager.instance.withTokenPvi;
    Response response = await httpClient.get(
      "/lugares",
      queryParameters: {
        'idTipoCasa': idTipoCasa,
        'idItem': idItem,
        'idProblema': idProblema,
        'idRecinto': idRecinto,
        'key': apiKey,
      },
    );
    return lugarFromMap(response.data as List);
  }

  Future<List<Item>> fetchUserSupportItem(String apiKey, int? idTipoCasa,
      int? idProblema, int? idLugar, int? idRecinto) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get(
      "/items",
      queryParameters: {
        'idTipoCasa': idTipoCasa,
        'idProblema': idProblema,
        'idLugar': idLugar,
        'idRecinto': idRecinto,
        'key': apiKey,
      },
    );
    return itemFromMap(response.data as List);
  }

  Future<UserSupportTypeWarranty> fetchTypeWarranty(
      String apiKey, int? idPropiedad, int? idItem, int? idLugar) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get(
      "/tiposgarantia",
      queryParameters: {
        'idPropiedad': idPropiedad,
        'idItem': idItem,
        //  'idLugar': idLugar,
        'key': apiKey,
      },
    );

    final test = userSupportTypeWarrantyFromMap(json.encode(response.data));
    return test.first;
  }

   sendEmailConfirm(
      String apiKey, String idSolicitud) async {
    final httpClient = HttpManager.instance.withTokenPvi;

    Response response = await httpClient.get(
      "/solicitudes/envia-correo-confirmacion-solicitudes",
      queryParameters: {
        'id_solicitud': idSolicitud,
        'key': apiKey,
      },
    );
  }

}
