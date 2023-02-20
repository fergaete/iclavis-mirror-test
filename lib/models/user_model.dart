import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class UserModel extends Equatable {
  UserModel({
    this.idCliente,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.fechaNacimiento,
    this.dni,
    this.nacionalidad,
    this.fono,
    this.email,
    this.calle,
    this.numero,
    this.depto,
    this.comuna,
    this.provincia,
    this.region,
    this.code,
    /* this.confirmed = false,
    this.hasAccess = false, */
  });

  @HiveField(0)
  final int? idCliente;

  @HiveField(1)
  final String? nombre;

  @HiveField(2)
  final String? apellidoPaterno;

  @HiveField(3)
  final String? apellidoMaterno;

  @HiveField(4)
  final String? fechaNacimiento;

  @HiveField(5)
  final String? dni;

  @HiveField(6)
  final String? nacionalidad;

  @HiveField(7)
  final String? fono;

  @HiveField(8)
  final String? email;

  @HiveField(9)
  final String? calle;

  @HiveField(10)
  final String? numero;

  @HiveField(11)
  final String? depto;

  @HiveField(12)
  final String? comuna;

  @HiveField(13)
  final String? provincia;

  @HiveField(14)
  final String? region;

  @HiveField(15)
  final String? code;

  UserModel copyWith({
    String? code,
  }) =>
      UserModel(
        idCliente: idCliente,
        nombre: nombre,
        apellidoPaterno: apellidoPaterno,
        apellidoMaterno: apellidoMaterno,
        fechaNacimiento: fechaNacimiento,
        dni: dni,
        nacionalidad: nacionalidad,
        fono: fono,
        email: email,
        calle: calle,
        numero: numero,
        depto: depto,
        comuna: comuna,
        provincia: provincia,
        region: region,
        code: code ?? '',
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        idCliente: json["idCliente"],
        nombre: json["nombre"] ?? '',
        apellidoPaterno: json["apellidoPaterno"] ?? '',
        apellidoMaterno: json["apellidoMaterno"] ?? '',
        fechaNacimiento: json["fecha_nacimiento"] ?? '',
        dni: json["rut"] ?? '',
        nacionalidad: json["nacionalidad"] ?? '',
        fono: json["fono"] ?? '',
        email: json["email"] ?? '',
        calle: json["direccion_calle"] ?? '',
        numero: json["direccion_numero"] ?? '',
        depto: json["direccion_depto"] ?? '',
        comuna: json["comuna"] ?? '',
        provincia: json["provincia"],
        region: json["region"],
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "nombre": nombre,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "fechaNacimiento": fechaNacimiento,
        "dni": dni,
        "nacionalidad": nacionalidad,
        "fono": fono,
        "email": email,
        "calle": calle,
        "numero": numero,
        "depto": depto,
        "comuna": comuna,
        "provincia": provincia,
        "region": region,
      };

  @override
  List<Object?> get props => [
        idCliente,
        nombre,
        apellidoPaterno,
        apellidoMaterno,
        fechaNacimiento,
        dni,
        nacionalidad,
        fono,
        email,
        calle,
        numero,
        depto,
        comuna,
        provincia,
        region,
      ];
}
