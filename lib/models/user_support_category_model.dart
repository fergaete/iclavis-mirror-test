import 'dart:convert';

List<UserSupportCategoryModel> userSupportCategoryModelFromJson(List data) =>
    List<UserSupportCategoryModel>.from(
      data.map(
        (e) => UserSupportCategoryModel.fromJson(e),
      ),
    );

String userSupportCategoryModelToJson(List<UserSupportCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class UserSupportCategoryModel {
  UserSupportCategoryModel({
    this.id,
    this.glosa,
    this.categorias,
  });

  int? id;
  String? glosa;
  List<Categoria>? categorias;

  factory UserSupportCategoryModel.fromJson(Map<String, dynamic> json) =>
      UserSupportCategoryModel(
        id: json["id"],
        glosa: json["glosa"],
        categorias: List<Categoria>.from(
            json["categorias"].map((x) => Categoria.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "glosa": glosa,
        "categorias": List<dynamic>.from(categorias!.map((x) => x.toJson())),
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


class TypeRequest {
  TypeRequest({
    this.id,
    this.glosa,
  });

  int? id;
  String? glosa;

  factory TypeRequest.fromJson(Map<String, dynamic> json) => TypeRequest(
    id: json["id"],
    glosa: json["glosa"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "glosa": glosa,
  };
}