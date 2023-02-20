import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:iclavis/models/user_support_problem_model.dart';
import 'package:iclavis/services/user_support/user_support_repository.dart';
import 'package:iclavis/utils/http/result.dart';

part 'post_sale_form_event.dart';
part 'post_sale_form_state.dart';

class PostSaleFormBloc extends Bloc<PostSaleFormEvent, PostSaleFormState> {
  final UserSupportRepository _userSupportRepository = UserSupportRepository();
  PostSaleFormBloc() : super(PostSaleFormInitial()) {
    on<PostSaleFormInitialLoaded>((event, emit) async {
      emit(PostSaleFormInProgress());

      try {
        final listRecinto = await _userSupportRepository.fetchRecintos(
            apiKey: event.apiKey,
            idTipoCasa: event.idTipoCasa,
            idProblema: event.idProblema,
            idItem: event.idItem,
            idLugar: event.idLugar);

        final userSupportDataForm = PostSaleDataForm(
          listRecinto: listRecinto.data,
        );
        emit(const PostSaleFormFileSuccess(listFile: []));
        emit(PostSaleFormInitialSuccess(result: userSupportDataForm));
      } on ResultException catch (e) {
        emit(PostSaleFormInitialFailure(result: e.result!));
      }
    });
    on<PostSaleFormSelectChange>((event, emit) async {
      emit(PostSaleFormSelectInProgress());

      try {
        List<Recinto>? listRecinto;
        List<Lugar>? listLugar;
        List<Item>? listItem;
        List<Problema>? listProblema;

        if (event.postSaleDataForm?.listRecinto == null) {
          await _userSupportRepository
              .fetchRecintos(
                  apiKey: event.apiKey,
                  idTipoCasa: event.idTipoCasa,
                  idProblema: event.idProblema,
                  idItem: event.idItem,
                  idLugar: event.idLugar)
              .then((v) => listRecinto = v.data);
          listLugar = null;
          listItem = null;
          listProblema = null;
        } else {
          listRecinto = event.postSaleDataForm?.listRecinto!;
          if (event.postSaleDataForm?.listLugar == null) {
            await _userSupportRepository
                .fetchLugares(
                    apiKey: event.apiKey,
                    idTipoCasa: event.idTipoCasa,
                    idRecinto: event.idRecinto,
                    idItem: event.idItem,
                    idProblema: event.idProblema)
                .then((v) => listLugar = v.data);
            listItem = null;
            listProblema = null;
          } else {
            listLugar = event.postSaleDataForm?.listLugar;
            if (event.postSaleDataForm?.listItem == null) {
              await _userSupportRepository
                  .fetchItem(
                      apiKey: event.apiKey,
                      idTipoCasa: event.idTipoCasa,
                      idRecinto: event.idRecinto,
                      idProblema: event.idProblema,
                      idLugar: event.idLugar)
                  .then((v) => listItem = v.data);

              listProblema = null;
            } else {
              listItem = event.postSaleDataForm?.listItem;
              if (event.postSaleDataForm?.listProblema == null) {
                await _userSupportRepository
                    .fetchProblema(
                        apiKey: event.apiKey,
                        idTipoCasa: event.idTipoCasa,
                        idRecinto: event.idRecinto,
                        idItem: event.idItem,
                        idLugar: event.idLugar)
                    .then((v) => listProblema = v.data);
              } else {
                listProblema = event.postSaleDataForm?.listProblema;
              }
            }
          }
        }
        final userSupportDataForm = PostSaleDataForm(
          listRecinto: listRecinto,
          listLugar: listLugar,
          listProblema: listProblema,
          listItem: listItem,
        );

        emit(PostSaleFormSelectSuccess(result: userSupportDataForm));
      } on ResultException catch (e) {
        emit(PostSaleFormSelectFailure(result: e.result!));
      }
    });
    on<PostSaleFormLoadwarranty>((event, emit) async {
      emit(PostSaleFormSelectInProgress());
      try {
        final typeWarranty = await _userSupportRepository.fetchWarranty(
            apiKey: event.apiKey,
            idPropiedad: event.idPropiedad,
            idLugar: event.idLugar,
            idItem: event.idItem);

        emit(PostSaleFormTypeWarrantySuccess(result: typeWarranty));
      } on ResultException catch (e) {
        emit(PostSaleFormSelectFailure(result: e.result!));
      }
    });
    on<PostSaleFormSended>((event, emit) async {
      emit(PostSaleFormSendedSuccessProgress());

      try {
        String result =
            await _userSupportRepository.sendPostSaleFormApplicationPvi(
          apiKey: event.apiKey,
          idProducto: event.idProduct,
        );

        await Future.forEach(event.listPostSaleForm, (e) async {
          final requestBody = {
            'key': event.apiKey,
            'idRecinto': e.idRecinto,
            'idLugar': e.idLugar,
            'idItem': e.idItem,
            'idProblema': e.idProblema,
            'descripcion': e.descripcion,
            'idSolicitud': result,
          };
          await _userSupportRepository.sendPostSaleFormRequestPvi(
              apiKey: event.apiKey,
              requestBody: requestBody,
              files: e.listFile);
        }).whenComplete(() async => await _userSupportRepository
            .sendEmailConfirm(apiKey: event.apiKey, idSolicitud: result));

        emit(PostSaleFormSendedSuccess());
      } on ResultException catch (e) {
        emit(PostSaleFormSendedFailure(result: e.result!));
      }
    });
    on<PostSaleFormDataAddFile>((event, emit) async {
      List<FilePost>? listFile;
      if (state is PostSaleFormFileSuccess) {
        listFile = (state as PostSaleFormFileSuccess).listFile;
      }
      listFile ??= [];
      listFile.add(event.file);

      emit(PostSaleFormFileSuccess(listFile: listFile));
    });
    on<PostSaleFormDataRemoveFile>((event, emit) async {
      List<FilePost> listFile = (state as PostSaleFormFileSuccess).listFile;

      int indexList = listFile.indexWhere((item) => item.id == event.idFile);

      if (listFile.length > 1) {
        listFile.removeAt(indexList);
      } else {
        listFile = [];
      }
      emit(PostSaleFormFileSuccess(listFile: listFile));
    });
  }
}
