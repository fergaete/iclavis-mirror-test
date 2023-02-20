import 'dart:convert';

List<UserSupportTypeWarranty> userSupportTypeWarrantyFromMap(String str) => List<UserSupportTypeWarranty>.from(json.decode(str).map((x) => UserSupportTypeWarranty.fromMap(x)));

String userSupportTypeWarrantyToMap(List<UserSupportTypeWarranty> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class UserSupportTypeWarranty {
  UserSupportTypeWarranty({
    this.estado,
    this.nombre,
  });

  String? estado;
  String? nombre;

  factory UserSupportTypeWarranty.fromMap(Map<String, dynamic> json) => UserSupportTypeWarranty(
    estado: json["estado"] == null ? null : json["estado"],
    nombre: json["nombre"] == null ? null : json["nombre"],
  );

  Map<String, dynamic> toMap() => {
    "estado": estado == null ? null : estado,
    "nombre": nombre == null ? null : nombre,
  };
}
