import 'dart:convert';

PropertyModel propertyModelFromJson(Map<String, dynamic> str) =>
    PropertyModel.fromJson(Map<String, dynamic>.from(str));

String propertyModelToJson(PropertyModel data) => json.encode(data.toJson());

class PropertyModel {
  PropertyModel({
    this.inmobiliaria,
    this.proyecto,
    this.negocios,
  });

  Inmobiliaria? inmobiliaria;
  Proyecto? proyecto;
  List<Negocio>? negocios;

  PropertyModel copyWith({
    List<Negocio>? negocios,
  }) =>
      PropertyModel(
        inmobiliaria: this.inmobiliaria,
        proyecto: this.proyecto,
        negocios: negocios ?? this.negocios,
      );

  factory PropertyModel.fromJson(Map<String, dynamic> json) => PropertyModel(
        inmobiliaria: Inmobiliaria.fromJson(json["inmobiliaria"]),
        proyecto: Proyecto.fromJson(json["proyecto"]),
        negocios: List<Negocio>.from(
            json["negocios"].map((x) => Negocio.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "inmobiliaria": inmobiliaria?.toJson(),
        "proyecto": proyecto?.toJson(),
        "negocios": List<dynamic>.from(negocios!.map((x) => x.toJson())),
      };
}

class Inmobiliaria {
  Inmobiliaria({
    this.nombre,
  });

  String? nombre;

  factory Inmobiliaria.fromJson(Map<String, dynamic> json) => Inmobiliaria(
        nombre: json["nombre"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
      };
}

class Negocio {
  Negocio({
    this.idGci,
    this.idPvi,
    this.estado,
    this.producto,
    this.productosSecundarios,
    this.isCurrent,
  });

  int? idGci;
  int? idPvi;
  String? estado;
  Producto? producto;
  List<ProductosSecundario>? productosSecundarios;
  bool? isCurrent;

  Negocio copyWith({
    bool? isCurrent,
  }) =>
      Negocio(
        idGci: this.idGci,
        idPvi: this.idPvi,
        estado: this.estado,
        producto: this.producto,
        productosSecundarios: this.productosSecundarios,
        isCurrent: isCurrent ?? this.isCurrent,
      );

  factory Negocio.fromJson(Map<String, dynamic> json) => Negocio(
        idGci: json["idGci"] ?? json["id"],
        idPvi: json["idPvi"],
        estado: json["estado"],
        producto: Producto.fromJson(json["producto"]),
        productosSecundarios:json["productosSecundarios"] is List ? List<ProductosSecundario>.from(
            json["productosSecundarios"]
                .map((x) => ProductosSecundario.fromJson(x))): [],
        isCurrent: json['isCurrent'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "idGci": idGci,
        "idPvi": idPvi,
        "estado": estado,
        "producto": producto?.toJson(),
        "productosSecundarios":
            List<dynamic>.from(productosSecundarios!.map((x) => x.toJson())),
        "isCurrent": isCurrent,
      };
}

class Producto {
  Producto({
    this.idGci,
    this.idPvi,
    this.nombre,
    this.orientacion,
    this.supTotal,
    this.tipo,
    this.idTipoCasa,
    this.piso,
    this.modelo,
    this.etapa,
    this.subagrupacion,
    this.fechaEntrega
  });

  int? idGci;
  int? idPvi;
  String? nombre;
  String? fechaEntrega;
  String? orientacion;
  double? supTotal;
  String? tipo;
  int? idTipoCasa;
  int? piso;
  Modelo? modelo;
  Etapa? etapa;
  Subagrupacion? subagrupacion;


  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        idGci: json["idGci"] ?? json["id"],
        idPvi: json["idPvi"],
        nombre: json["nombre"],
        orientacion: json["orientacion"],
        supTotal: json["supTotal"].toDouble(),
        tipo: json["tipo"],
        idTipoCasa: json["idTipoCasa"] ?? 1001,
        piso: json["piso"],
        modelo: Modelo.fromJson(json["modelo"]),
        etapa: Etapa.fromJson(json["etapa"]),
        subagrupacion: Subagrupacion.fromJson(json["subagrupacion"]),
        fechaEntrega: json["fechaEntrega"] ?? "0000-00-00"
      );

  Map<String, dynamic> toJson() => {
        "idGci": idGci,
        "idPvi": idPvi,
        "nombre": nombre,
    "fechaEntrega":fechaEntrega,
        "orientacion": orientacion,
        "supTotal": supTotal,
        "tipo": tipo,
        "idTipoCasa": idTipoCasa,
        "piso": piso,
        "modelo": modelo?.toJson(),
        "etapa": etapa?.toJson(),
        "subagrupacion": subagrupacion?.toJson(),

      };
}

class Etapa {
  Etapa({
    this.id,
    this.nombre,
  });

  int? id;
  String? nombre;

  factory Etapa.fromJson(Map<String, dynamic> json) => Etapa(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}

class Modelo {
  Modelo({
    this.id,
    this.nombre,
    this.cantPisos,
    this.cantDormitorios,
    this.cantBanos,
    this.supMunicipal,
    this.supUtil,
    this.supPalier,
    this.supLoggia,
    this.supInterior,
    this.supTerraza,
    this.supTotal,
    this.plano1,
    this.plano2,
    this.plano3,
    this.plano4,
    this.plano5,
    this.plano6,
  });

  int? id;
  String? nombre;
  int? cantPisos;
  int? cantDormitorios;
  int? cantBanos;
  double? supMunicipal;
  double? supUtil;
  double? supPalier;
  double? supLoggia;
  num? supInterior;
  double? supTerraza;
  double? supTotal;
  String? plano1;
  String? plano2;
  String? plano3;
  String? plano4;
  String? plano5;
  String? plano6;

  factory Modelo.fromJson(Map<String, dynamic> json) => Modelo(
        id: json["id"],
        nombre: json["nombre"],
        cantPisos: 0,
        cantDormitorios: json["cantDormitorios"] is int
            ? json["cantDormitorios"]
            : int.parse(json["cantDormitorios"]),
        cantBanos: json["cantBanos"],
        supMunicipal: json["supMunicipal"].toDouble(),
        supUtil: json["supUtil"].toDouble(),
        supPalier: json["supPalier"].toDouble(),
        supLoggia: json["supLoggia"].toDouble(),
        supInterior: json["supInterior"],
        supTerraza: json["supTerraza"].toDouble(),
        supTotal: json["supTotal"].toDouble(),
        plano1: json["plano1"],
        plano2: json["plano2"],
        plano3: json["plano3"],
        plano4: json["plano4"],
        plano5: json["plano5"],
        plano6: json["plano6"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cantPisos": cantPisos,
        "cantDormitorios": cantDormitorios,
        "cantBanos": cantBanos,
        "supMunicipal": supMunicipal,
        "supUtil": supUtil,
        "supPalier": supPalier,
        "supLoggia": supLoggia,
        "supInterior": supInterior,
        "supTerraza": supTerraza,
        "supTotal": supTotal,
        "plano1": plano1,
        "plano2": plano2,
        "plano3": plano3,
        "plano4": plano4,
        "plano5": plano5,
        "plano6": plano6,
      };
}

class Subagrupacion {
  Subagrupacion({
    this.id,
    this.nombre,
    this.fechaRecepcionMunicipal,
    this.fechaEntrega,
  });

  int? id;
  String? nombre;
  String? fechaRecepcionMunicipal;
  String? fechaEntrega;

  factory Subagrupacion.fromJson(Map<String, dynamic> json) => Subagrupacion(
        id: json["id"],
        nombre: json["nombre"],
        fechaRecepcionMunicipal: json["fechaRecepcionMunicipal"],
        fechaEntrega: json["fechaEntrega"] == null ? null : json["fechaEntrega"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "fechaRecepcionMunicipal": fechaRecepcionMunicipal,
        "fechaEntrega": fechaEntrega,
      };
}

class ProductosSecundario {
  ProductosSecundario({
    this.id,
    this.nombre,
    this.tipo,
    this.piso,
  });

  int? id;
  String? nombre;
  String? tipo;
  String? piso;

  factory ProductosSecundario.fromJson(Map<String, dynamic> json) =>
      ProductosSecundario(
        id: json["id"]  is int
            ? json["id"]
            : int.parse(json["id"]??'0'),
        nombre: json["nombre"] ?? "",
        tipo: json["tipo"]??"",
        piso: json["piso"]??"",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "tipo": tipo,
        "piso": piso,
      };
}

class Proyecto {
  Proyecto({
    this.id,
    this.logo,
    this.nombre,
    this.direccion,
    this.descripcion,
  });

  int? id;
  String? logo;
  String? nombre;
  String? direccion;
  String? descripcion;

  factory Proyecto.fromJson(Map<String, dynamic> json) => Proyecto(
        id: json["idGci"] ?? json["id"],
        logo: json["logo"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "nombre": nombre,
        "direccion": direccion,
        "descripcion": descripcion,
      };
}
