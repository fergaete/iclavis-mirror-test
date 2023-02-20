// To parse this JSON data, do
//
//     final userSupportHistoryModel = userSupportHistoryModelFromJson(jsonString);

import 'dart:convert';

List<UserSupportHistoryModel> userSupportHistoryModelFromJson(List data) =>
    List<UserSupportHistoryModel>.from(
        data.map((e) => UserSupportHistoryModel.fromJson(e)));

String userSupportHistoryModelToJson(List<UserSupportHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class UserSupportHistoryModel {
  UserSupportHistoryModel({
    this.id,
    this.tipoSolicitud,
    this.estadoSolicitud,
    this.propiedadNombre,
    this.tipoDeConsulta,
    this.folio,
    this.fechaInicio,
    this.fechaCierre,
    this.descripcion,
    this.categoriaConsulta,
    this.cantidadDeRequerimientos,
    this.documento,
  });

  String? id;
  int? tipoSolicitud;
  EstadoSolicitud? estadoSolicitud;
  String? propiedadNombre;
  String? tipoDeConsulta;
  String? folio;
  String? fechaInicio;
  String? fechaCierre;
  String? descripcion;
  String? categoriaConsulta;
  String? cantidadDeRequerimientos;
  List<Documento>? documento;

  factory UserSupportHistoryModel.fromJson(Map<String, dynamic> json) => UserSupportHistoryModel(
    id: json["id"],
    tipoSolicitud: json["tipoSolicitud"] == null ? null : json["tipoSolicitud"]=="pvi"? 1:0,
    estadoSolicitud: json["estadoSolicitud"] == null ? null : EstadoSolicitud.fromJson(json["estadoSolicitud"]),
    propiedadNombre: json["propiedadNombre"] == null ? null : (json["propiedadNombre"] is String) ? json["propiedadNombre"]:"",
    tipoDeConsulta: json["tipoDeConsulta"] ?? null,
    folio: json["folio"] == null ? null : json["folio"],
    fechaInicio: json["fechaInicio"],
    fechaCierre: json["fechaCierre"] ?? null,
    descripcion: json["descripcion"] ?? null,
    categoriaConsulta: json["categoriaConsulta"] ?? null,
    cantidadDeRequerimientos: json["cantidadDeRequerimientos"] ?? null,
    documento: json["documento"] == null ? null : List<Documento>.from(json["documento"].map((x) => Documento.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id== null ? null : id,
    "tipoSolicitud": tipoSolicitud == null ? null : tipoSolicitud,
    "estadoSolicitud": estadoSolicitud == null ? null : estadoSolicitud?.toJson(),
    "propiedadNombre": propiedadNombre == null ? null : propiedadNombre,
    "tipoDeConsulta": tipoDeConsulta == null ? null : tipoDeConsulta,
    "folio": folio == null ? null : folio,
    "fechaInicio": fechaInicio == null ? null : fechaInicio,
    "fechaCierre": fechaCierre == null ? null : fechaCierre,
    "descripcion": descripcion == null ? null : descripcion,
    "categoriaConsulta": categoriaConsulta == null ? null : categoriaConsulta,
    "cantidadDeRequerimientos": cantidadDeRequerimientos == null ? null : cantidadDeRequerimientos,
    "documento": documento == null ? null : List<dynamic>.from(documento!.map((x) => x.toJson())),
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

class EstadoSolicitud {
  EstadoSolicitud({
    this.id,
    this.glosa,
  });

  String? id;
  String? glosa;

  factory EstadoSolicitud.fromJson(Map<String, dynamic> json) => EstadoSolicitud(
    id: json["id"].toString(),
    glosa: json["glosa"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "glosa": glosa,
  };
}
