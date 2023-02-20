part of 'post_sale_form_bloc.dart';

abstract class PostSaleFormState {
  const PostSaleFormState();

  @override
  List<Object> get props => [];
}

class PostSaleFormInitial extends PostSaleFormState {}

class PostSaleFormInProgress extends PostSaleFormState {}

class PostSaleFormSelectInProgress extends PostSaleFormState {}

class PostSaleFormSendedSuccess extends PostSaleFormState {}

class PostSaleFormSendedSuccessProgress extends PostSaleFormState {}

class PostSaleFormSendedFailure extends PostSaleFormState {
  final Result result;
  const PostSaleFormSendedFailure({required this.result});
  @override
  String toString() => 'PostSaleFormSendedFailure { Result: $result }';
}

class PostSaleFormInitialSuccess extends PostSaleFormState {
  final PostSaleDataForm result;

  const PostSaleFormInitialSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'PostSaleFormInitialSuccess { Result: $result }';
}

class PostSaleFormSelectSuccess extends PostSaleFormState {
  final PostSaleDataForm result;

  PostSaleFormSelectSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'PostSaleFormSelectSuccess { Result: $result }';
}

class PostSaleFormInitialFailure extends PostSaleFormState {
  final Result result;

  const PostSaleFormInitialFailure({required this.result});

  @override
  String toString() => 'PostSaleFormInitialFailure { Result: $result }';
}

class PostSaleFormSelectFailure extends PostSaleFormState {
  final Result result;

  const PostSaleFormSelectFailure({required this.result});

  @override
  String toString() => 'PostSaleFormInitialFailure { Result: $result }';
}

class PostSaleFormTypeWarrantySuccess extends PostSaleFormState {
  final Result result;

  const PostSaleFormTypeWarrantySuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'PostSaleFormInitialSuccess { Result: $result }';
}

class PostSaleFormFileSuccess extends PostSaleFormState {
  final List<FilePost> listFile;

  const PostSaleFormFileSuccess({required this.listFile});

  @override
  List<Object> get props => [listFile];

  @override
  String toString() => 'PostSaleFormFileSuccess { Result: $listFile }';
}
