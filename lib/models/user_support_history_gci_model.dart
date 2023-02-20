import 'dart:convert';

List<UserSupportHistoryGciModel> userSupportHistoryGciModelFromJson(List data) =>
    List<UserSupportHistoryGciModel>.from(
        data.map((e) => UserSupportHistoryGciModel.fromJson(e)));

String userSupportHistoryGciModelToJson(List<UserSupportHistoryGciModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class UserSupportHistoryGciModel {
  UserSupportHistoryGciModel({
    this.id,
    this.producto,
    this.tipoConsulta,
  });

  int? id;
  Producto? producto;
  TipoConsulta? tipoConsulta;

  factory UserSupportHistoryGciModel.fromJson(Map<String, dynamic> json) =>
      UserSupportHistoryGciModel(
        id: json["id"],
        producto: Producto.fromJson(json["producto"]),
        tipoConsulta: TipoConsulta.fromJson(json["tipoConsulta"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "producto": producto?.toJson(),
    "tipoConsulta": tipoConsulta?.toJson(),
  };
}

class Producto {
  Producto({
    this.id,
    this.nombre,
  });

  int? id;
  String? nombre;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    id: json["id"],
    nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
  };
}

class TipoConsulta {
  TipoConsulta({
    this.id,
    this.glosa,
    this.categoria,
    this.responsable,
    this.consulta,
    this.fechaCreacion,
  });

  int? id;
  String? glosa;
  Categoria? categoria;
  Responsable? responsable;
  String? consulta;
  DateTime? fechaCreacion;

  factory TipoConsulta.fromJson(Map<String, dynamic> json) => TipoConsulta(
    id: json["id"],
    glosa: json["glosa"],
    categoria: Categoria.fromJson(json["categoria"]),
    responsable: Responsable.fromJson(json["responsable"]),
    consulta: json["consulta"],
    fechaCreacion: DateTime.parse(json["fechaCreacion"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "glosa": glosa,
    "categoria": categoria?.toJson(),
    "responsable": responsable?.toJson(),
    "consulta": consulta,
    "fechaCreacion": fechaCreacion?.toIso8601String(),
  };
}

class Categoria {
  Categoria({
    this.id,
    this.glosa,
  });

  int? id;
  String? glosa;

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
    id: json["id"],
    glosa: json["glosa"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "glosa": glosa,
  };
}

class Responsable {
  Responsable({
    this.nombre,
    this.mail,
    this.cargo,
  });

  String? nombre;
  String? mail;
  String? cargo;

  factory Responsable.fromJson(Map<String, dynamic> json) => Responsable(
    nombre: json["nombre"],
    mail: json["mail"],
    cargo: json["cargo"],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "mail": mail,
    "cargo": cargo,
  };
}
