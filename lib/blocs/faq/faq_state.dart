part of 'faq_bloc.dart';

abstract class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object> get props => [];
}

class FaqInitial extends FaqState {}

class FaqInProgress extends FaqState {}

class FaqSuccess extends FaqState {
  final Result result;

  const FaqSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'FaqSuccess { Result: $result }';
}

class FaqFailure extends FaqState {
  final Result result;

  const FaqFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'FaqFailure { Result: $result }';
}
