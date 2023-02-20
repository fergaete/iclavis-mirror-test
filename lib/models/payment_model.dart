// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromMap(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(Map<String, dynamic> str) =>
    PaymentModel.fromMap(Map<String, dynamic>.from(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toMap());

class PaymentModel {
  PaymentModel({
    this.codigoConvenioOtrosPagos,
    required this.negocios,
  });

  String? codigoConvenioOtrosPagos;
  List<Negocio> negocios;

  PaymentModel copyWith({
     String? codigoConvenioOtrosPagos,
    List<Negocio>? negocios,
  }) =>
      PaymentModel(
        codigoConvenioOtrosPagos:
            codigoConvenioOtrosPagos ?? this.codigoConvenioOtrosPagos,
        negocios: negocios ?? this.negocios,
      );

  factory PaymentModel.fromMap(Map<String, dynamic> json) => PaymentModel(
        codigoConvenioOtrosPagos: json["codigoConvenioOtrosPagos"],
        negocios:
            List<Negocio>.from(json["negocios"].map((x) => Negocio.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "codigoConvenioOtrosPagos": codigoConvenioOtrosPagos,
        "negocios": List<dynamic>.from(negocios.map((x) => x.toMap())),
      };
}

class Negocio {
  Negocio({
    this.promesa,
    this.productoPrincipal,
    required this.productosSecundarios,
    required this.cuotas,
    this.isCurrent,
  });

  Promesa? promesa;
  ProductoPrincipal? productoPrincipal;
  List<ProductosSecundario> productosSecundarios;
  List<Cuota> cuotas;
  bool? isCurrent;

  Negocio copyWith({
    bool? isCurrent,
  }) =>
      Negocio(
        promesa: promesa,
        productoPrincipal: productoPrincipal,
        productosSecundarios: productosSecundarios,
        cuotas: cuotas,
        isCurrent: isCurrent ?? this.isCurrent,
      );

  factory Negocio.fromMap(Map<String, dynamic> json) => Negocio(
        promesa: Promesa.fromMap(json["promesa"]),
        productoPrincipal: ProductoPrincipal.fromMap(json["productoPrincipal"]),
        productosSecundarios: List<ProductosSecundario>.from(
            json["productosSecundarios"]
                .map((x) => ProductosSecundario.fromMap(x))),
        cuotas: List<Cuota>.from(json["cuotas"].map((x) => Cuota.fromMap(x))),
        isCurrent: json['isCurrent'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "promesa": promesa?.toMap(),
        "productoPrincipal": productoPrincipal?.toMap(),
        "productosSecundarios":
            List<dynamic>.from(productosSecundarios.map((x) => x.toMap())),
        "cuotas": List<dynamic>.from(cuotas.map((x) => x.toMap())),
        "isCurrent": isCurrent,
      };
}

class Cuota {
  Cuota({
    this.id,
    this.numero,
    this.codigoTipoCuota,
    this.montoUf,
    this.montoPesos,
    this.pagadoUf,
    this.pagadoPesos,
    this.fechaVencimiento,
    this.estado,
    required this.pagos,
  });

  num? id;
  String? numero;
  String? codigoTipoCuota;
  num? montoUf;
  num? montoPesos;
  num? pagadoUf;
  num? pagadoPesos;
  DateTime? fechaVencimiento;
  String? estado;
  List<Pago> pagos;

  factory Cuota.fromMap(Map<String, dynamic> json) => Cuota(
        id: json["id"],
        numero: json["numero"],
        codigoTipoCuota: json["codigoTipoCuota"],
        montoUf: json["montoUF"].toDouble(),
        montoPesos: json["montoPesos"],
        pagadoUf: json["pagadoUF"],
        pagadoPesos: json["pagadoPesos"],
        fechaVencimiento: DateTime.parse(json["fechaVencimiento"]),
        estado: json["estado"],
        pagos: List<Pago>.from(json["pagos"].map((x) => Pago.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "numero": numero,
        "codigoTipoCuota": codigoTipoCuota,
        "montoUF": montoUf,
        "montoPesos": montoPesos,
        "pagadoUF": pagadoUf,
        "pagadoPesos": pagadoPesos,
        "fechaVencimiento": fechaVencimiento?.toIso8601String(),
        "estado": estado,
        "pagos": List<dynamic>.from(pagos.map((x) => x.toMap())),
      };
}

class Pago {
  Pago({
    this.id,
    this.monto,
    this.fecha,
    this.tipoDocumento,
    this.estadoDocumento,
  });

  num? id;
  double? monto;
  String? fecha;
  String? tipoDocumento;
  String? estadoDocumento;

  factory Pago.fromMap(Map<String, dynamic> json) => Pago(
        id: json["id"],
        monto: json["monto"],
        fecha: json["fecha"],
        tipoDocumento: json["tipoDocumento"],
        estadoDocumento: json["estadoDocumento"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "monto": monto,
        "fecha": fecha,
        "tipoDocumento": tipoDocumento,
        "estadoDocumento": estadoDocumento,
      };
}

class ProductoPrincipal {
  ProductoPrincipal({
    this.id,
    this.nombre,
    this.tipo,
    this.precio,
    this.precioLista,
    this.descUf,
    this.descPorcent,
  });

  num? id;
  String? nombre;
  String? tipo;
  num? precio;
  num? precioLista;
  num? descUf;
  num? descPorcent;

  factory ProductoPrincipal.fromMap(Map<String, dynamic> json) =>
      ProductoPrincipal(
        id: json["id"],
        nombre: json["nombre"],
        tipo: json["tipo"],
        precio: json["precio"],
        precioLista: json["precioLista"],
        descUf: json["descUf"],
        descPorcent: json["descPorcent"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "tipo": tipo,
        "precio": precio,
        "precioLista": precioLista,
        "descUf": descUf,
        "descPorcent": descPorcent,
      };
}

class ProductosSecundario {
  ProductosSecundario({
    this.id,
    this.nombre,
    this.tipo,
    this.precio,
    this.precioListo,
    this.descPorcent,
    this.descUf,
  });

  num? id;
  String? nombre;
  String? tipo;
  num? precio;
  num? precioListo;
  num? descPorcent;
  num? descUf;

  factory ProductosSecundario.fromMap(Map<String, dynamic> json) =>
      ProductosSecundario(
        id: json["id"],
        nombre: json["nombre"],
        tipo: json["tipo"],
        precio: json["precio"],
        precioListo: json["precioListo"],
        descPorcent: json["descPorcent"],
        descUf: json["descUF"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "tipo": tipo,
        "precio": precio,
        "precioListo": precioListo,
        "descPorcent": descPorcent,
        "descUF": descUf,
      };
}

class Promesa {
  Promesa({
    this.id,
    this.estado,
    this.totalPrecioLista,
    this.descUfPrecioLista,
    this.descPorcentPrecioLista,
    this.descuentoUf,
    this.descuentoPorcent,
    this.subTotal,
    this.total,
  });

  int? id;
  String? estado;
  num? totalPrecioLista;
  num? descUfPrecioLista;
  num? descPorcentPrecioLista;
  num? descuentoUf;
  num? descuentoPorcent;
  num? subTotal;
  num? total;

  factory Promesa.fromMap(Map<String, dynamic> json) => Promesa(
        id: json["id"],
        estado:json["estado"] ??'' ,
        totalPrecioLista: json["totalPrecioLista"],
        descUfPrecioLista: json["descUFPrecioLista"],
        descPorcentPrecioLista: json["descPorcentPrecioLista"],
        descuentoUf: json["descuentoUF"],
        descuentoPorcent: json["descuentoPorcent"],
        subTotal: json["subTotal"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "estado":estado??'',
        "totalPrecioLista": totalPrecioLista,
        "descUFPrecioLista": descUfPrecioLista,
        "descPorcentPrecioLista": descPorcentPrecioLista,
        "descuentoUF": descuentoUf,
        "descuentoPorcent": descuentoPorcent,
        "subTotal": subTotal,
        "total": total,
      };
}

