part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentInProgress extends DocumentState {}
class DocumentDownloadInProgress extends DocumentState {}

class DocumentSuccess extends DocumentState {
  final Result result;

  const DocumentSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'DocumentSuccess { Result: $result }';
}

class DocumentDownloadSuccess extends DocumentState {
  final Result result;

  const DocumentDownloadSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'DocumentDownloadSuccess { Result: $result }';
}

class DocumentFailure extends DocumentState {
  final Result result;

  const DocumentFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'DocumentFailure { Result: $result }';
}
