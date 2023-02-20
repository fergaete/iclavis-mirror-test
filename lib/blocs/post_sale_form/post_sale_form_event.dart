part of 'post_sale_form_bloc.dart';

@immutable
abstract class PostSaleFormEvent {
  const PostSaleFormEvent();
}

class PostSaleFormInitialLoaded extends PostSaleFormEvent {
  final String apiKey;
  final int idTipoCasa;
  final int? idRecinto;
  final int? idItem;
  final int? idLugar;
  final int? idProblema;

  const PostSaleFormInitialLoaded(
      {required this.apiKey,
      required this.idTipoCasa,
      this.idRecinto,
      this.idItem,
      this.idLugar,
      this.idProblema});

  @override
  List<Object?> get props => [apiKey, idTipoCasa, idRecinto, idItem, idLugar];

  @override
  String toString() => 'PostSaleFormInitialLoaded { }';
}

class PostSaleFormSelectChange extends PostSaleFormEvent {
  final String apiKey;
  final int idTipoCasa;
  final int? idRecinto;
  final int? idItem;
  final int? idLugar;
  final int? idProblema;
  final PostSaleDataForm? postSaleDataForm;

  const PostSaleFormSelectChange(
      {required this.apiKey,
      required this.idTipoCasa,
      this.idRecinto,
      this.idItem,
      this.idLugar,
      this.idProblema,
      this.postSaleDataForm});

  @override
  List<Object?> get props => [apiKey, idTipoCasa, idRecinto, idItem, idLugar];

  @override
  String toString() => 'PostSaleFormSelectChange { }';
}

class PostSaleFormLoadwarranty extends PostSaleFormEvent {
  final String apiKey;
  final int idPropiedad;
  final int? idItem;
  final int? idLugar;

  const PostSaleFormLoadwarranty(
      {required this.apiKey,
      required this.idPropiedad,
      this.idItem,
      this.idLugar});

  List<Object?> get props => [apiKey, idItem, idLugar];

  @override
  String toString() => 'PostSaleFormSelectChange { }';
}

class PostSaleFormSended extends PostSaleFormEvent {
  final String apiKey;
  final int idProduct;
  final List<PostSaleFormModel> listPostSaleForm;

  const PostSaleFormSended({
    required this.apiKey,
    required this.idProduct,
    required this.listPostSaleForm,
  });

  @override
  String toString() =>
      'NewRequestUserSupportRequestSended { ApiKey: $apiKey, RequestBody: $listPostSaleForm}';
}

class PostSaleFormDataAddFile extends PostSaleFormEvent {
  final FilePost file;

  PostSaleFormDataAddFile({required this.file});
  @override
  String toString() => 'PostSaleFormDataAddFile { }';
}

class PostSaleFormDataRemoveFile extends PostSaleFormEvent {
  final int idFile;

  PostSaleFormDataRemoveFile({required this.idFile});
  @override
  String toString() => 'PostSaleFormDataRemoveFile { }';
}
