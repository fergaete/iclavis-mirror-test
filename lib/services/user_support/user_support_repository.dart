import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';

import 'user_support_service.dart';

class UserSupportRepository {
  final _userSupportService = UserSupportService();
  final _handler = ExceptionHandler();

  Future<Result> fetchCategories({required String apiKey}) async {
    try {
      final categories = await _userSupportService.fetchUserSupportCategories(
        apiKey,
      );

      return Result(data: categories);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchCategoriesPvi({required String apiKey}) async {
    try {
      final categories =
          await _userSupportService.fetchUserSupportCategoriesPvi(
        apiKey,
      );

      return Result(data: categories);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> sendUserSupportRequest(
      {required String apiKey, Map<String, dynamic>? requestBody}) async {
    try {
      final categories = await _userSupportService.sendUserSupportRequest(
        apiKey,
        requestBody!,
      );

      return Result(data: categories);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> sendUserSupportRequestPvi(
      {required String apiKey, required Map<String, dynamic> requestBody}) async {
    try {
      final result = await _userSupportService.sendUserSupportPviRequest(
        apiKey,
        requestBody,
      );

      return Result(data: result);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<String> sendPostSaleFormApplicationPvi(
      {required String apiKey,required int idProducto}) async {
    try {
      final response = await _userSupportService.sendPostSaleFormApplicationPvi(
        apiKey,
        idProducto,
      );

      return response.data["SUCCESS"]["id"];
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> sendPostSaleFormRequestPvi(
      {required String apiKey,required Map<String, dynamic> requestBody,List<FilePost>? files}) async {
    try {
      final result = await _userSupportService.sendPostSaleRequest(
        apiKey,
        requestBody,
        files
      );

      return Result(data: result);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchHistoryGci(
      {required String apiKey, required String dni,required int idProyecto}) async {
    try {
      final history = await _userSupportService.fetchUserSupportHistoryGci(
        apiKey,
        dni,
        idProyecto,
      );

      return Result(data: history);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchHistory(
      {required String apiKey,required  String dni, required int idPropiedad}) async {
    try {
      final history = await _userSupportService.fetchUserSupportHistory(
        apiKey,
        dni,
        idPropiedad,
      );

      return Result(data: history);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchHistoryRequest(
      {required String apiKey, required String dni,required int idProyecto, required String idRequest}) async {
    try {
      final history = await _userSupportService.fetchUserSupportHistoryRequest(
          apiKey, dni, idProyecto, idRequest);

      return Result(data: history);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchProblema(
      {required String apiKey,
      int? idTipoCasa,
      int? idItem,
      int? idLugar,
      int? idRecinto}) async {
    try {
      final problema = await _userSupportService.fetchUserSupportProblema(
          apiKey, idTipoCasa, idItem, idLugar, idRecinto);

      return Result(data: problema);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchRecintos(
      {required String apiKey,
      int? idTipoCasa,
      int? idItem,
      int? idLugar,
      int? idProblema}) async {
    try {
      final recinto = await _userSupportService.fetchUserSupportRecinto(
          apiKey, idTipoCasa, idItem, idLugar, idProblema);

      return Result(data: recinto);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchLugares(
      {required String apiKey,
      int? idTipoCasa,
      int? idItem,
      int? idProblema,
      int? idRecinto}) async {
    try {
      final lugar = await _userSupportService.fetchUserSupportLugar(
          apiKey, idTipoCasa, idItem, idProblema, idRecinto);

      return Result(data: lugar);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchItem(
      {required String apiKey,
      int? idTipoCasa,
      int? idProblema,
      int? idLugar,
      int?  idRecinto}) async {
    try {
      final item = await _userSupportService.fetchUserSupportItem(
          apiKey, idTipoCasa, idProblema, idLugar, idRecinto);

      return Result(data: item);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<Result> fetchWarranty(
      {required String apiKey, int? idPropiedad, int? idItem, int? idLugar}) async {
    try {
      final item = await _userSupportService.fetchTypeWarranty(
        apiKey,
        idPropiedad,
        idItem,
        idLugar,
      );
      return Result(data: item);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }
   sendEmailConfirm(
      {required String apiKey, required String idSolicitud}) async {
    try {
     /*  await _userSupportService.sendEmailConfirm(
        apiKey,
        idSolicitud,
      );*/
    } catch (e) {
      throw Exception(e);
    }
  }
}
