import 'dart:convert';

ProjectModel projectModelFromMap(String str) =>
    ProjectModel.fromMap(json.decode(str));

List<ProjectModel> projectModelFromJson(List data) =>
    List<ProjectModel>.from(data.map((e) => ProjectModel.fromMap(e)));

String projectModelToMap(ProjectModel data) => json.encode(data.toMap());

String projectModelToJson(List<ProjectModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toMap())));

class ProjectModel {
  ProjectModel({
    this.proyecto,
    this.inmobiliaria,
    required this.isCurrent,
  });

  Proyecto? proyecto;
  Inmobiliaria? inmobiliaria;
  bool isCurrent;

  ProjectModel copyWith({
    bool? isCurrent,
  }) =>
      ProjectModel(
        proyecto: proyecto,
        inmobiliaria: inmobiliaria,
        isCurrent: isCurrent ?? this.isCurrent,
      );

  factory ProjectModel.fromMap(Map<String, dynamic> json) => ProjectModel(
        proyecto: json["proyecto"] == null
            ? null
            : Proyecto.fromMap(json["proyecto"]),
        inmobiliaria: json["inmobiliaria"] == null
            ? null
            : Inmobiliaria.fromMap(json["inmobiliaria"]),
        isCurrent: json['isCurrent'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "proyecto": proyecto == null ? null : proyecto?.toMap(),
        "inmobiliaria": inmobiliaria == null ? null : inmobiliaria?.toMap(),
      };
}

class Inmobiliaria {
  Inmobiliaria({
    this.gci,
    this.pvi,
    this.configuraciones,
  });

  InmobiliariaGci? gci;
  List<PviElement>? pvi;
  Configuraciones? configuraciones;

  factory Inmobiliaria.fromMap(Map<String, dynamic> json) => Inmobiliaria(
        gci: json["gci"] == null ? null : InmobiliariaGci.fromMap(json["gci"]),
        pvi: json["pvi"] == null
            ? null
            : json["pvi"].length > 0
                ? List<PviElement>.from(
                    json["pvi"].map((x) => PviElement.fromMap(x)))
                : null,
    configuraciones: json["configuraciones"] == null ? null : Configuraciones.fromMap(json["configuraciones"]),
      );

  Map<String, dynamic> toMap() => {
        "gci": gci == null ? null : gci?.toMap(),
        "pvi":
            pvi == null ? null : List<dynamic>.from(pvi!.map((x) => x.toMap())),
    "configuraciones": configuraciones == null ? null : configuraciones?.toMap(),
      };
}

class InmobiliariaGci {
  InmobiliariaGci({
    this.id,
    this.logo,
    this.apikey,
    this.nombre,
  });

  int? id;
  String? logo;
  String? apikey;
  String? nombre;

  factory InmobiliariaGci.fromMap(Map<String, dynamic> json) => InmobiliariaGci(
        id: json["id"],
        logo: json["logo"],
        apikey: json["apikey"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "logo": logo == null ? null : logo,
        "apikey": apikey == null ? null : apikey,
        "nombre": nombre == null ? null : nombre,
      };
}

class PviElement {
  PviElement({
    this.id,
    this.logo,
    this.apikey,
    this.nombre,
    this.poseeSac,
  });

  String? id;
  String? logo;
  String? apikey;
  String? nombre;
  bool? poseeSac;

  factory PviElement.fromMap(Map<String, dynamic> json) => PviElement(
        id: json["id"] == null ? null : json["id"],
        logo: json["logo"] == null ? null : json["logo"],
        apikey: json["apikey"] == null ? null : json["apikey"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        poseeSac: json["posee_sac"] == null ? null : json["posee_sac"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "logo": logo == null ? null : logo,
        "apikey": apikey == null ? null : apikey,
        "nombre": nombre == null ? null : nombre,
        "posee_sac": poseeSac == null ? null : poseeSac,
      };
}

class Configuraciones {
  Configuraciones({
    required this.poseePagos,
    required this.poseeSac,
  });

  bool poseePagos;
  bool poseeSac;

  factory Configuraciones.fromMap(Map<String, dynamic> json) => Configuraciones(
    poseePagos: json["posee_pagos"] ?? false,
    poseeSac: json["posee_sac"] ?? false,
  );

  Map<String, dynamic> toMap() => {
    "posee_pagos": poseePagos,
    "posee_sac": poseeSac,
  };
}

class Proyecto {
  Proyecto({
    this.gci,
    this.pvi,
  });

  ProyectoGci? gci;
  ProyectoPvi? pvi;

  factory Proyecto.fromMap(Map<String, dynamic> json) => Proyecto(
        gci: json["gci"] == null ? null : ProyectoGci.fromMap(json["gci"]),
        pvi: json["pvi"] == null ? null : ProyectoPvi.fromMap(json["pvi"]),
      );

  Map<String, dynamic> toMap() => {
        "gci": gci == null ? null : gci!.toMap(),
        "pvi": pvi == null ? null : pvi!.toMap(),
      };
}

class ProyectoGci {
  ProyectoGci({
    this.id,
    this.glosa,
    this.direccion,
    this.formularioContacto,
    this.logo,
  });

  int? id;
  String? glosa;
  String? direccion;
  FormularioContacto? formularioContacto;
  String? logo;

  factory ProyectoGci.fromMap(Map<String, dynamic> json) => ProyectoGci(
        id: json["id"] == null ? null : json["id"],
        glosa: json["glosa"] == null ? null : json["glosa"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        formularioContacto: json["formularioContacto"] == null
            ? null
            : FormularioContacto.fromMap(json["formularioContacto"]),
        logo: json["logo"] == null ? null : json["logo"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "glosa": glosa == null ? null : glosa,
        "direccion": direccion == null ? null : direccion,
        "formularioContacto":
            formularioContacto == null ? null : formularioContacto?.toMap(),
        "logo": logo == null ? null : logo,
      };
}

class FormularioContacto {
  FormularioContacto({
    this.activo,
    this.mensaje,
  });

  bool? activo;
  dynamic mensaje;

  factory FormularioContacto.fromMap(Map<String, dynamic> json) =>
      FormularioContacto(
        activo: json["activo"] == null ? null : json["activo"],
        mensaje: json["mensaje"],
      );

  Map<String, dynamic> toMap() => {
        "activo": activo == null ? null : activo,
        "mensaje": mensaje,
      };
}

class ProyectoPvi {
  ProyectoPvi({
    this.id,
    this.glosa,
    this.direccion,
    this.comuna,
    this.codigoProyecto,
    this.cantidadEtapas,
    this.fechaCreacion,
    this.fechaEdicion,
    this.proyectoGciId,
  });

  String? id;
  String? glosa;
  String? direccion;
  String? comuna;
  String? codigoProyecto;
  String? cantidadEtapas;
  DateTime? fechaCreacion;
  DateTime? fechaEdicion;
  String? proyectoGciId;

  factory ProyectoPvi.fromMap(Map<String, dynamic> json) => ProyectoPvi(
        id: json["id"] == null ? null : json["id"],
        glosa: json["glosa"] == null ? null : json["glosa"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        comuna: json["comuna"] == null ? null : json["comuna"],
        codigoProyecto:
            json["codigoProyecto"] == null ? null : json["codigoProyecto"],
        cantidadEtapas:
            json["cantidadEtapas"] == null ? null : json["cantidadEtapas"],
        fechaCreacion: json["fechaCreacion"] == null
            ? null
            : DateTime.parse(json["fechaCreacion"]),
        fechaEdicion: json["fechaEdicion"] == null
            ? null
            : DateTime.parse(json["fechaEdicion"]),
        proyectoGciId:
            json["proyectoGciId"] == null ? null : json["proyectoGciId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "glosa": glosa == null ? null : glosa,
        "direccion": direccion == null ? null : direccion,
        "comuna": comuna == null ? null : comuna,
        "codigoProyecto": codigoProyecto == null ? null : codigoProyecto,
        "cantidadEtapas": cantidadEtapas == null ? null : cantidadEtapas,
        "fechaCreacion":
            fechaCreacion == null ? null : fechaCreacion?.toIso8601String(),
        "fechaEdicion":
            fechaEdicion == null ? null : fechaEdicion?.toIso8601String(),
        "proyectoGciId": proyectoGciId == null ? null : proyectoGciId,
      };
}

