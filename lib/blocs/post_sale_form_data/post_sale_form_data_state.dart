part of 'post_sale_form_data_bloc.dart';

abstract class PostSaleFormDataState {
  const PostSaleFormDataState();

  @override
  List<Object> get props => [];
}

class PostSaleFormDataInitial extends PostSaleFormDataState {}

class PostSaleFormDataInProgress extends PostSaleFormDataState {}

class PostSaleFormDataSuccess extends PostSaleFormDataState {
  final List<PostSaleFormModel> listFormData;

  const PostSaleFormDataSuccess({required this.listFormData});

  @override
  List<Object> get props => [listFormData];

  @override
  String toString() => 'PostSaleFormDataSuccess { Reslt: $listFormData }';
}
