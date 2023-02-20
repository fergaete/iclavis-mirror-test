import 'dart:convert';

List<UserSupportHistoryRequestModel> UserSupportHistoryRequestModelFromJson(
        List data) =>
    List<UserSupportHistoryRequestModel>.from(
        data.map((e) => UserSupportHistoryRequestModel.fromJson(e)));

String userSupportHistoryRequestModelToJson(
        List<UserSupportHistoryRequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserSupportHistoryRequestModel {
  UserSupportHistoryRequestModel(
      {this.folioRequerimiento,
      this.estadoRequerimiento,
      this.criticidad,
      this.estadoGarantia,
      this.urgencia,
      this.ultimaActualizacion,
      this.detalle,
      this.descripcion,
      this.documentos,
      this.idSolicitud});

  String? folioRequerimiento;
  EstadoRequerimiento? estadoRequerimiento;
  String? criticidad;
  String? estadoGarantia;
  String? urgencia;
  String? ultimaActualizacion;
  String? detalle;
  String? descripcion;
  List<Documento>? documentos;
  String? idSolicitud;

  factory UserSupportHistoryRequestModel.fromJson(Map<String, dynamic> json) =>
      UserSupportHistoryRequestModel(
          folioRequerimiento: json["folioRequerimiento"] == null
              ? null
              : json["folioRequerimiento"],
          estadoRequerimiento: json["estadoRequerimiento"] == null
              ? null
              : EstadoRequerimiento.fromJson(json["estadoRequerimiento"]),
          criticidad: json["criticidad"] == null ? null : json["criticidad"],
          estadoGarantia:
              json["estadoGarantia"] == null ? null : json["estadoGarantia"],
          urgencia: json["urgencia"] == null ? null : json["urgencia"],
          ultimaActualizacion: json["ultimaActualizacion"] == null
              ? null
              : json["ultimaActualizacion"],
          detalle: json["detalle"] == null ? null : json["detalle"],
          descripcion: json["descripcion"] == null ? null : json["descripcion"],
          documentos: json["documentos"] == null
              ? null
              : List<Documento>.from(
                  json["documentos"].map((x) => Documento.fromJson(x))),
          idSolicitud:
              json["idSolicitud"] == null ? null : json["idSolicitud"]);

  Map<String, dynamic> toJson() => {
        "folioRequerimiento":
            folioRequerimiento == null ? null : folioRequerimiento,
        "estadoRequerimiento":
            estadoRequerimiento == null ? null : estadoRequerimiento?.toJson(),
        "criticidad": criticidad == null ? null : criticidad,
        "estadoGarantia": estadoGarantia == null ? null : estadoGarantia,
        "urgencia": urgencia == null ? null : urgencia,
        "ultimaActualizacion":
            ultimaActualizacion == null ? null : ultimaActualizacion,
        "detalle": detalle == null ? null : detalle,
        "descripcion": descripcion == null ? null : descripcion,
        "documentos": documentos == null
            ? null
            : List<dynamic>.from(documentos!.map((x) => x.toJson())),
        "idSolicitud": idSolicitud == null ? null : idSolicitud,
      };
}

class Documento {
  Documento({
    this.nombre,
    this.url,
  });

  String? nombre;
  String? url;

  factory Documento.fromJson(Map<String, dynamic> json) => Documento(
        nombre: json["nombre"] == null ? null : json["nombre"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre == null ? null : nombre,
        "url": url == null ? null : url,
      };
}

class EstadoRequerimiento {
  EstadoRequerimiento({
    this.id,
    this.glosa,
  });

  String? id;
  String? glosa;

  factory EstadoRequerimiento.fromJson(Map<String, dynamic> json) =>
      EstadoRequerimiento(
        id: json["id"] == null ? null : json["id"].toString(),
        glosa: json["glosa"] == null ? null : json["glosa"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "glosa": glosa == null ? null : glosa,
      };
}
