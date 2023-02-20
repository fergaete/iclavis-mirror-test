import 'dart:convert';

List<FaqModel> faqModelFromJson(List data) =>
    List<FaqModel>.from(data.map((e) => FaqModel.fromJson(e)));

String faqModelToJson(List<FaqModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class FaqModel {
  FaqModel({
    required this.id,
    this.detalle,
    required this.preguntasFrecuentes,
  });

  int id;
  String? detalle;
  List<PreguntasFrecuente> preguntasFrecuentes;

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        id: json["id"],
        detalle: json["detalle"],
        preguntasFrecuentes: List<PreguntasFrecuente>.from(
            json["preguntasFrecuentes"]
                .map((x) => PreguntasFrecuente.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "detalle": detalle,
        "preguntasFrecuentes":
            List<dynamic>.from(preguntasFrecuentes.map((x) => x.toJson())),
      };
}

class PreguntasFrecuente {
  PreguntasFrecuente({
    this.id,
    this.idProyecto,
    this.tipo,
    this.glosa,
    this.respuesta,
  });

  int? id;
  int? idProyecto;
  int? tipo;
  String? glosa;
  String? respuesta;

  factory PreguntasFrecuente.fromJson(Map<String, dynamic> json) =>
      PreguntasFrecuente(
        id: json["id"],
        idProyecto: json["idProyecto"],
        tipo: json["tipo"],
        glosa: json["glosa"],
        respuesta: json["respuesta"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idProyecto": idProyecto,
        "tipo": tipo,
        "glosa": glosa,
        "respuesta": respuesta,
      };
}
