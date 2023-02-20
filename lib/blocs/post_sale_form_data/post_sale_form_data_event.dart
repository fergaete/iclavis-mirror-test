part of 'post_sale_form_data_bloc.dart';

@immutable
abstract class PostSaleFormDataEvent {}

class PostSaleFormDataInit extends PostSaleFormDataEvent {
  final List<PostSaleFormModel>? listFormData;
  PostSaleFormDataInit({this.listFormData});
  @override
  String toString() => 'PostSaleFormDataInit { }';
}

class PostSaleFormDataAddRequest extends PostSaleFormDataEvent {
  PostSaleFormDataAddRequest();
  @override
  String toString() => 'PostSaleFormDataAddRequest { }';
}

class PostSaleFormDataCloseRequest extends PostSaleFormDataEvent {
  final PostSaleFormModel itemFormData;

  PostSaleFormDataCloseRequest({required this.itemFormData});
  @override
  String toString() => 'PostSaleFormDataCloseRequest { }';
}
class PostSaleFormDataRemoveRequest extends PostSaleFormDataEvent {
  final int id;

  PostSaleFormDataRemoveRequest({required this.id});
  @override
  String toString() => 'PostSaleFormDataRemoveRequest { }';
}

