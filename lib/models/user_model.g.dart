// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      idCliente: fields[0] as int?,
      nombre: fields[1] as String?,
      apellidoPaterno: fields[2] as String?,
      apellidoMaterno: fields[3] as String?,
      fechaNacimiento: fields[4] as String?,
      dni: fields[5] as String?,
      nacionalidad: fields[6] as String?,
      fono: fields[7] as String?,
      email: fields[8] as String?,
      calle: fields[9] as String?,
      numero: fields[10] as String?,
      depto: fields[11] as String?,
      comuna: fields[12] as String?,
      provincia: fields[13] as String?,
      region: fields[14] as String?,
      code: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.idCliente)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.apellidoPaterno)
      ..writeByte(3)
      ..write(obj.apellidoMaterno)
      ..writeByte(4)
      ..write(obj.fechaNacimiento)
      ..writeByte(5)
      ..write(obj.dni)
      ..writeByte(6)
      ..write(obj.nacionalidad)
      ..writeByte(7)
      ..write(obj.fono)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.calle)
      ..writeByte(10)
      ..write(obj.numero)
      ..writeByte(11)
      ..write(obj.depto)
      ..writeByte(12)
      ..write(obj.comuna)
      ..writeByte(13)
      ..write(obj.provincia)
      ..writeByte(14)
      ..write(obj.region)
      ..writeByte(15)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
