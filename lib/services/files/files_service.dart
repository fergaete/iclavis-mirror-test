import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:iclavis/utils/http/http_manager.dart';
import 'package:iclavis/models/document_model.dart';
import 'package:iclavis/models/image_model.dart';
import 'package:iclavis/models/video_model.dart';

class FilesService {
  Future<List<DocumentModel>> fetchDocument(
      String dni, String apiKey, int idProyecto) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.get(
      "/archivos/documentos",
      queryParameters: {'rut': dni, 'apiKey': apiKey, 'proyectoId': idProyecto},
    );

    return documentModelFromJson(response.data);
  }

  Future<List<ImageModel>> fetchImage(
      String dni, String apiKey, int idProyecto) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.get(
      "/archivos/fotos",
      queryParameters: {'rut': dni, 'apiKey': apiKey, 'proyectoId': idProyecto},
    );

    return imageModelFromJson(response.data);
  }

  Future<List<VideoModel>> fetchVideo(
      String dni, String apiKey, int idProyecto) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.get(
      "/archivos/videos",
      queryParameters: {'rut': dni, 'apiKey': apiKey, 'proyectoId': idProyecto},
    );
    return videoModelFromJson(response.data);
  }

  Future<String> downloadDocument(
      String documentUrl, String documentName) async {
    final httpClient = HttpManager.instance.init;

    final documentType = RegExp(r"(doc|docx|pdf|png|rtf|jpg)$").stringMatch(documentUrl);


    Directory dir;

    final status = await Permission.storage.request();

    if (status.isGranted) {
      dir = await getApplicationDocumentsDirectory();

      final savePath = '${dir.path}/$documentName.$documentType';

      await httpClient.download(
        documentUrl,
        savePath,
        deleteOnError: true,
      );

      return savePath;
    } else {
      return '';
    }
  }
}

final image = [
  {
    "categoryName": "proyecto",
    "id": 1,
    "images": [
      {
        "name": "Alegria",
        "url":
            "https://caracoltv.brightspotcdn.com/dims4/default/7b184d8/2147483647/strip/true/crop/1500x720+0+0/resize/1200x576!/format/webp/quality/90/?url=https%3A%2F%2Fcaracol-brightspot.s3-us-west-2.amazonaws.com%2Fassets%2Fshock%2Fcontent_files%2F2018_05%2Fimage_article%2Femojis_que_no_son_lo_que_parecen_.jpg"
      },
      {
        "name": "Alegria",
        "url":
            "https://images.pexels.com/users/avatars/206430/free-jpg-242.jpeg"
      }
    ]
  },
  {
    "categoryName": "avance",
    "id": 2,
    "images": [
      {
        "name": "Luz",
        "url":
            "https://caracoltv.brightspotcdn.com/dims4/default/7b184d8/2147483647/strip/true/crop/1500x720+0+0/resize/1200x576!/format/webp/quality/90/?url=https%3A%2F%2Fcaracol-brightspot.s3-us-west-2.amazonaws.com%2Fassets%2Fshock%2Fcontent_files%2F2018_05%2Fimage_article%2Femojis_que_no_son_lo_que_parecen_.jpg"
      }
    ]
  },
  {
    "categoryName": "entorno",
    "id": 3,
    "images": [
      {
        "name": "Blanca",
        "url":
            "https://caracoltv.brightspotcdn.com/dims4/default/7b184d8/2147483647/strip/true/crop/1500x720+0+0/resize/1200x576!/format/webp/quality/90/?url=https%3A%2F%2Fcaracol-brightspot.s3-us-west-2.amazonaws.com%2Fassets%2Fshock%2Fcontent_files%2F2018_05%2Fimage_article%2Femojis_que_no_son_lo_que_parecen_.jpg"
      }
    ]
  },
  {
    "categoryName": "piloto",
    "id": 4,
    "images": [
      {
        "name": "White",
        "url":
            "https://caracoltv.brightspotcdn.com/dims4/default/7b184d8/2147483647/strip/true/crop/1500x720+0+0/resize/1200x576!/format/webp/quality/90/?url=https%3A%2F%2Fcaracol-brightspot.s3-us-west-2.amazonaws.com%2Fassets%2Fshock%2Fcontent_files%2F2018_05%2Fimage_article%2Femojis_que_no_son_lo_que_parecen_.jpg"
      }
    ]
  },
  {
    "categoryName": "otros",
    "id": 5,
    "images": [
      {
        "name": "Dude",
        "url":
            "https://caracoltv.brightspotcdn.com/dims4/default/7b184d8/2147483647/strip/true/crop/1500x720+0+0/resize/1200x576!/format/webp/quality/90/?url=https%3A%2F%2Fcaracol-brightspot.s3-us-west-2.amazonaws.com%2Fassets%2Fshock%2Fcontent_files%2F2018_05%2Fimage_article%2Femojis_que_no_son_lo_que_parecen_.jpg"
      }
    ]
  }
];

final video = [
  {
    "id": 1,
    "name": "video 1",
    "url":
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"
  },
  {
    "id": 2,
    "name": "video 2",
    "url":
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"
  }
];
