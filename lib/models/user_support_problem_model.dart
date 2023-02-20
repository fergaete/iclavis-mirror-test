import 'dart:convert';

class PostSaleDataForm{
  
  List<Problema>? listProblema;
  List<Lugar>? listLugar;
  List<Item>? listItem;
  List<Recinto>? listRecinto;

  PostSaleDataForm({
      this.listProblema, this.listLugar, this.listItem, this.listRecinto});
}

List<Problema> problemaFromMap(List data) => List<Problema>.from(data.map((x) => Problema.fromMap(x)));

String problemaToMap(List<Problema> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Problema {
  Problema({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Problema.fromMap(Map<String, dynamic> json) => Problema(
    id: json["id"] == null ? null : json["id"],
    nombre: json["nombre"] == null ? null : json["nombre"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "nombre": nombre == null ? null : nombre,
  };
}

List<Lugar> lugarFromMap(List data) => List<Lugar>.from(data.map((x) => Lugar.fromMap(x)));

String lugarToMap(List<Lugar> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Lugar {
  Lugar({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Lugar.fromMap(Map<String, dynamic> json) => Lugar(
    id: json["id"] == null ? null : json["id"],
    nombre: json["nombre"] == null ? null : json["nombre"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "nombre": nombre == null ? null : nombre,
  };
}

List<Item> itemFromMap(List data) => List<Item>.from(data.map((x) => Item.fromMap(x)));

String itemToMap(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Item {
  Item({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    id: json["id"] == null ? null : json["id"],
    nombre: json["nombre"] == null ? null : json["nombre"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "nombre": nombre == null ? null : nombre,
  };
}

List<Recinto> recintoFromMap(List data) => List<Recinto>.from(data.map((x) => Recinto.fromMap(x)));

String recintoToMap(List<Recinto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Recinto {
  Recinto({
    this.id,
    this.nombre,
  });

  String? id;
  String? nombre;

  factory Recinto.fromMap(Map<String, dynamic> json) => Recinto(
    id: json["id"] == null ? null : json["id"],
    nombre: json["nombre"] == null ? null : json["nombre"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "nombre": nombre == null ? null : nombre,
  };
}




