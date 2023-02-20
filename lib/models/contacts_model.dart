import 'dart:convert';

List<ContactsModel> contactsModelFromJson(List data) =>
    List<ContactsModel>.from(data.map((e) => ContactsModel.fromJson(e)));

String contactsModelToJson(List<ContactsModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class ContactsModel {
  ContactsModel({
    required this.id,
    this.nombre,
    this.cargo,
    this.contactarEnCasoDe,
    this.telefono,
    this.mail,
  });

  int id;
  String? nombre;
  String? cargo;
  String? contactarEnCasoDe;
  String? telefono;
  String? mail;

  factory ContactsModel.fromJson(Map<String, dynamic> json) => ContactsModel(
        id: json["id"],
        nombre: json["nombre"],
        cargo: json["cargo"],
        contactarEnCasoDe: json["contactarEnCasoDe"],
        telefono: json["telefono"],
        mail: json["mail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cargo": cargo,
        "contactarEnCasoDe": contactarEnCasoDe,
        "telefono": telefono,
        "mail": mail,
      };
}
