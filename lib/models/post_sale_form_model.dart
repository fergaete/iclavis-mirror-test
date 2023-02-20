import 'dart:io';
import 'dart:html' as html;

import 'package:iclavis/models/user_support_type_warranty.dart';

class PostSaleFormModel {
  int? id;
  int? estado;
  int? idRecinto;
  String? nameReciento;
  int? idLugar;
  String? nameLugar;
  int? idItem;
  String? nameItem;
  int? idProblema;
  String? nameProblema;
  String? descripcion;
  UserSupportTypeWarranty? warranty;
  List<FilePost>? listFile;

  PostSaleFormModel(
      {this.id,
      this.estado,
      this.idRecinto,
      this.nameReciento,
      this.idLugar,
      this.nameLugar,
      this.idItem,
      this.nameItem,
      this.idProblema,
      this.nameProblema,
      this.descripcion,
      this.warranty,
      this.listFile});

  PostSaleFormModel copyWith({
    int? id,
    int? estado,
    int? idRecinto,
    String? nameReciento,
    int? idLugar,
    String? nameLugar,
    int? idItem,
    String? nameItem,
    int? idProblema,
    String? nameProblema,
    String? descripcion,
    UserSupportTypeWarranty? warranty,
    List<FilePost>? listFile
  }) =>
      PostSaleFormModel(
          id: id ?? this.id,
          estado: estado ?? this.estado,
          idRecinto: idRecinto ?? this.idRecinto,
          nameReciento:nameReciento ?? this.nameReciento ,
          idLugar: idLugar ?? this.idLugar,
          nameLugar:nameLugar ?? this.nameLugar ,
          idItem: idItem ?? this.idItem,
          nameItem:nameItem ?? this.nameItem ,
          idProblema: idProblema ?? this.idProblema,
          nameProblema:nameProblema ?? this.nameProblema ,
          descripcion: descripcion ?? this.descripcion,
          warranty: warranty ?? this.warranty,
          listFile: listFile ?? this.listFile);
}

class FilePost{

  int? id;
  String? name;
  int? type;
  File? file;
  List<int>? fileWeb;

  FilePost({this.id,this.name,this.type, this.file,this.fileWeb});


}
